# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'better_error_message'
  s.version = "1.1.1"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Junwen", "Christian"]
  s.email = %q{x1022069@gmail.com}
  s.homepage = 'http://github.com/'
  s.summary = 'Better Error Message plugin for Rails'
  s.description = 'This plugin gives you the option to not have a better error msg'

  s.rubygems_version = '>= 1.3.5'
  
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
