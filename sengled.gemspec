require_relative 'lib/sengled/version'

Gem::Specification.new do |spec|
  spec.name          = "sengled"
  spec.version       = Sengled::VERSION
  spec.authors       = ["Grant Sparks"]
  spec.email         = ["grantpatricksparks@gmail.com"]

  spec.summary       = %q{Ruby library for managing Sengled brand smart fixtures.}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/gps1784/sengled.rb"
  spec.license       = "MIT"
  #spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/gps1784/sengled.rb"
  spec.metadata["changelog_uri"] = spec.homepage # TODO: Put your gem's CHANGELOG.md URL here.

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "benchmark-ips", "~> 2.8"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "rdoc", "~> 6.0"

  spec.add_runtime_dependency "colorize", "~> 0.8"
end
