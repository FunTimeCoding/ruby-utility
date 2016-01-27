# encoding: UTF-8
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'ruby_utility/version'

Gem::Specification.new do |s|
  s.name = 'ruby-utility'
  s.version = NAME::VERSION
  s.authors = ['Alexander Reitzel']
  s.email = ['funtimecoding@gmail.com']
  s.licenses = ['MIT']
  s.homepage = ''
  s.summary = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}
  s.rubyforge_project = 'ruby_utility'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
