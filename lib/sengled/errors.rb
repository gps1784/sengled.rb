module Sengled
  class BasicError < StandardError; end

  class API
    class APIError < Sengled::BasicError; end
  end # class API

  class Device
    class DeviceError < Sengled::BasicError; end
  end # class Device
end # class Sengled
