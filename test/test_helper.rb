require "simplecov"
SimpleCov.start()

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "sengled"

require "minitest/autorun"