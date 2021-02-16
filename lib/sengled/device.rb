require "colorized_string"

module Sengled
  class Device
    def initialize(raw)
      @raw         = raw
    end # initialize()

    def inspect()
      str = "#<#{self.class.name}:#{@raw['deviceUuid']} "
      str << @raw['attributes']['name'].inspect << " "
      if( @raw['attributes']['isOnline'] == '0' )
        str << ColorizedString["OFFLINE"].white.on_red << " "
      else
        str << ColorizedString["ONLINE"].black.on_green << " "
      end
      if( @raw['attributes']['onoff'] == '0' )
        str << ColorizedString["OFF"].white.on_red
      else
        str << ColorizedString["ON"].black.on_green
      end
      str << ">"
    end # inspect()
  end # class Device
end # module Sengled
