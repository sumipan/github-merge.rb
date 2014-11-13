require 'logger'

module Github
module Merge

  class Merger

    attr_reader :base_ref, :head_ref

    def initialize(options)
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

      @options = {
        :user => options[:user],
        :repo => options[:repo],
      }

      @github = Github::Client.new
      @github.setup(options)
    end

    def setup(base, head)
      @base_ref = @github.git_data.references.get(@options.merge({:ref => 'heads/' + base})).body

      begin
        @head_ref = @github.git_data.references.get(@options.merge({:ref => 'heads/' + head})).body
      rescue
        @github.git_data.references.create(@options.merge({
          :ref => 'refs/heads/' + head,
          :sha => base_ref.object.sha
        })).body

        @head_ref = @github.git_data.references.get(@options.merge({:ref => 'heads/' + head})).body
      end
    end

    def merge(ref, commit_message)
      @github.repos.merging.merge(@options.merge({
        :base => @head_ref.ref.sub(/^\/refs\/heads\//, ''),
        :head => ref,
        :commit_message => commit_message
      }))
    end

    def cleanup(ref=nil)
      if block_given? then

        page = 1
        delete_refs = []

        while true do
          response = @github.git_data.references.list(@options.merge({
            :page => page,
            :per_page => 100,
          })).to_a

          response.each do |ref|
            is_delete = yield ref
            if is_delete then
              delete_refs.push(ref)
            end
          end

          page += 1

          break if response.size < 100
        end

        @log.info(sprintf('%s branches affected', delete_refs.size))

        delete_refs.each do |delete_ref|
          @github.git_data.references.delete(@options.merge({
            :ref => delete_ref.ref.sub(/refs/, '')
          }))

          @log.info(sprintf('"%s" is deleted', delete_ref.ref.sub(/refs\/heads\//, '')))
        end

      elsif ref != nil then
        delete_ref = @github.git_data.references.get(@options.merge({
          :ref => 'heads/' + ref
        })).body

        @github.git_data.references.delete(@options.merge({
          :ref => delete_ref.ref.sub(/refs/, '')
        }))
      else
        raise 'invalid argument ref'
      end
    end
  end
end
end
