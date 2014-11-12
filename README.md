# github-merge

Merge specific branch with Github API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'github-merge'
```

And then execute:

    $ bundle

## Usage

```ruby
require 'github-merge'

merger = Github::Merge.new
merger.setup({
  :user => user,
  :repo => repo,
  :oauth_token => token,
})

merger.init({:base => base, :head => new_branch_name})
merger.merge(mergableBranchA_name)
merger.merge(mergableBranchB_name)
merger.merge(unmergableBranchC_name) # raise
```

## Contributing

1. Fork it ( https://github.com/sumipan/github-merge.rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
