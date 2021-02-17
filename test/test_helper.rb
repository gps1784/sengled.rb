$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "simplecov"
SimpleCov.start() do
  coverage_dir('docs/coverage')
end

require "sengled"

require "minitest/autorun"
