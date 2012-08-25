# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chart/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jason W. May"]
  gem.email         = ["jmay@pobox.com"]
  gem.description   = %q{Chart model construction routines for Numbrary}
  gem.summary       = %q{Chart model construction routines for Numbrary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "chart"
  gem.require_paths = ["lib"]
  gem.version       = Chart::VERSION

  gem.add_development_dependency "rake", "~> 0.9.2"
  gem.add_development_dependency "rspec", "~> 2.9.0"
  gem.add_development_dependency "guard-rspec", "~> 0.7.0"
end
