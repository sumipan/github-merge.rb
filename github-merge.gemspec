# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_merge/version'

Gem::Specification.new do |spec|
  spec.name          = "github-merge"
  spec.version       = Github::Merge::VERSION
  spec.authors       = ["takashi nagayasu"]
  spec.email         = ["ngys@g-onion.org"]
  spec.summary       = %q{Merge specific branch with Github API.}
  spec.description   = %q{Merge specific branch with Github API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "github_api"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
