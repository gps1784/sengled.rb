require "colorized_string"

module Sengled
  class Device

    ONLINE  = ON  = '1'
    OFFLINE = OFF = '0'

    def initialize(raw, api: nil)
      @raw = raw
      @api = api
    end # initialize()

    # READ-ONLY functions
    # these functions are intended to simplify queries
    # we use functions instead of variables to allow
    # the method aliases to work as intended

    def isOnline()
      return @raw['attributes']['isOnline'] == ONLINE
    end # isOnline()

    def isOffline()
      return @raw['attributes']['isOnline'] == OFFLINE
    end # isOffline()

    alias :online? :isOnline
    alias :offline? :isOffline

    def isOn()
      return @raw['attributes']['onoff'] == ON
    end # isOn()

    def isOff()
      return @raw['attributes']['onoff'] == OFF
    end # isOff()

    alias :on? :isOn
    alias :off? :isOff

    def deviceUuid()
      return @raw['deviceUuid']
    end # deviceUuid()

    alias :uuid :deviceUuid

    # WRITE functions
    # these functions are intended to simply API access
    # in order to alter device settings. many of these
    # functions are intended to be chainable,
    # to ease programming with Sengled::Device objects

    def on()
      @api.device_set_on_off(device: self, onoff: ON.to_i)
      return self
    end # on()

    def off()
      @api.device_set_on_off(device: self, onoff: OFF.to_i)
      return self
    end # off()

    def onoff=(val)
      if(  val == OFF || val == OFF.to_i || val == 'OFF')
        return (@raw['attributes']['onoff'] = OFF)
      elsif(val == ON || val == ON.to_i  || val == 'ON')
        return (@raw['attributes']['onoff'] = ON)
      else
        raise(DeviceError, "Cannot interpret #{val} as ON or OFF")
      end
      return (@raw['attributes']['onoff'] = val)
    end

    # inspect()
    # for now, this is intended to fill all the basic
    # details on a single line of text, like a
    # normal `#inspect()` method

    def inspect()
      str = "#<#{self.class.name}:#{uuid()} "
      str << @raw['attributes']['productCode'] << " "
      str << @raw['attributes']['name'].inspect << " "
      if( online?() )
        str << ColorizedString[" ONLINE "].black.on_green << " "
      else
        str << ColorizedString[" OFFLINE "].white.on_red << " "
      end
      if( on?() )
        str << ColorizedString[" ON "].black.on_green
      else
        str << ColorizedString[" OFF "].white.on_red
      end
      str << ">"
    end # inspect()
  end # class Device
end # module Sengled
