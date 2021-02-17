module Sengled
  class BasicError < StandardError; end

  class API
    class APIError < Sengled::BasicError; end

  end # class API
end # class Sengled
