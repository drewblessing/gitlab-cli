# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab_cli/version'

Gem::Specification.new do |gem|
  gem.name          = "gitlab_cli"
  gem.version       = GitlabCli::VERSION
  gem.authors       = ["Drew Blessing"]
  gem.email         = ["drew.blessing@buckle.com"]
  gem.description   = %q{Gitlab Command Line Tool}
  gem.summary       = %q{Many people prefer to work from the CLI when possible. This tool aims to bring some of the GitLab functionality into the CLI to avoid repeated trips to the web UI}
  gem.homepage      = "https://github.com/drewblessing/gitlab-cli"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "thor", [">= 0.17.0", "<0.19"]
  gem.add_runtime_dependency "json", "~> 1.7.7"
  gem.add_runtime_dependency "rest-client", "~> 1.6.7"
end
