# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuegrowler/version'

Gem::Specification.new do |spec|
  spec.name          = "cuegrowler"
  spec.version       = Cuegrowler::VERSION
  spec.authors       = ["Thai Pangsakulyanont"]
  spec.email         = ["org.yi.dttvb@gmail.com"]
  spec.summary       = %q{Growl the current track using a cuesheet.}
  spec.description   = %q{Growl the current track using a cuesheet.}
  spec.homepage      = "https://github.com/dtinth/cuegrowler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "rubycue"
  spec.add_runtime_dependency "docopt"
  spec.add_runtime_dependency "osaka"
  spec.add_runtime_dependency "growl"
end
