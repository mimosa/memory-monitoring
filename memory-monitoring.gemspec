# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'memory_monitoring/version'

Gem::Specification.new do |spec|
  spec.name          = "memory-monitoring"
  spec.version       = MemoryMonitoring::VERSION
  spec.authors       = ["Howl王"]
  spec.email         = ["howl.wong@gmail.com"]
  spec.summary       = %q{ Memory Monitoring }
  spec.description   = %q{ Provides support for Memory monitor for Rack compatible web applications. }
  spec.homepage      = "https://github.com/mimosa/memory-monitoring"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'awesome_print', '~> 1.2'
end
