# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'base_packager'

Gem::Specification.new do |spec|
  spec.name          = "base_packager"
  spec.version       = BasePackager::VERSION
  spec.authors       = ["Jordi Noguera"]
  spec.email         = ["jordi@pivotallabs.com"]
  spec.summary       = %q{Base buildpack packager}
  spec.description   = %q{Base buildpack packager}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "rubyzip"
end
