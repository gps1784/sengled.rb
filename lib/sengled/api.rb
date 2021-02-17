require 'json'
require 'net/http'
require 'net/https'
require 'pp'

require 'colorized_string'

require 'sengled/device'
require 'sengled/device/commands'
require 'sengled/errors'

module Sengled
  class API

    SENGLED_URL = "https://element.cloud.sengled.com/zigbee/"

    def initialize(username: nil, password: nil, session: nil, skip_login: false)
      @devices  = nil
      @session  = session # data from 'cookie'/'set-cookie'
      if( !skip_login )
        if( username.nil? || password.nil?)
          raise(APIError, "Either skip_login: must be true or username: and password: must be provided")
        end
        login(username: username, password: password)
      end
    end # initialize()

    def inspect()
      str = "#<#{self.class.name}: "
      if( @session )
        str << ColorizedString[" @session:ACTIVE "].black.on_green
      else
        str << ColorizedString[" @session:INACTIVE "].white.on_red
      end
      str << ">"
    end # inspect()

    def login(username:, password:, force: false)
      if( !@session || force )
        post(path: "customer/login.json",
          # parameters of post
          "os_type": "android",
          "user": username,
          "pwd": password,
          "uuid": "xxxx"
        )
      end # if @seesion && !force
      return self
    end # login()

    def get_device_details(force: false)
      if( @devices.nil? || force )
        response    = post(path: "device/getDeviceDetails.json")
        data        = JSON.parse(response.body)
        devices_raw = []
        data["deviceInfos"].each do |gateway|
          devices_raw.concat(gateway["lampInfos"] || [])
        end
        @devices = devices_raw.map do |dev|
          Sengled::Device.new(dev, api: self)
        end
        #pp devices_raw, @devices
        pp @devices
      end
      return @devices
    end # get_device_details()

    alias :get_devices :get_device_details
    alias :devices     :get_device_details

    def device_set_group(cmd:, devices:, **body)
      body['cmdID'] = cmd
      body['deviceUuidList'] = get_uuids(devices)
      post(path: "device/deviceSetGroup.json")
      return self
    end # device_set_group()

    alias :set_devices :device_set_group

    def device_set_on_off(device:, onoff:)
      uuid = get_uuid(device)
      response = post(path: "device/deviceSetOnOff.json",
        'deviceUuid': uuid,
        'onoff': onoff
      )
      if( response.is_a?(Net::HTTPSuccess) )
        device.onoff = onoff
        return True
      else
        raise(APIError, "Unable to set device (#{device.inspect}) onoff (#{onoff})")
        return False
      end
    end # device_set_on_off()

    alias :set_device :device_set_on_off
    alias :set_on_off :device_set_on_off

    private
    def get_uuids(devices)
      arr = []
      if( devices === Array )
        arr = devices.map do |device|
          get_uuid(device)
        end # devices.each
      else
        arr = [get_uuid(devices)]
      end # if devices
      return arr
    end # get_uuids()

    def get_uuid(device)
      case(device)
      when Sengled::Device
        return device.uuid
      when String
        return device
      else
        raise(ArgumentError, "Cannot extract UUID from #{device.inspect}")
      end # case(device)
    end # get_uuid()

    def post(path:, use_ssl: true, root_path: nil, **body)
      root_path ||= SENGLED_URL
      url = URI.parse(root_path + path)
      response = Net::HTTP.start(url.host, url.port, use_ssl: use_ssl) do |https|
        request = Net::HTTP::Post.new(url)
        if( @session )
          puts "Using existing cookie: #{@session.inspect}"
          request['Cookie'] = @session
        end # if @session
        request['Content-Type'] = 'application/json'
        request.body            = body.to_json
        https.request(request)
      end # Net::HTTP.start()
      if( response['Set-Cookie'] )
        puts "New cookie: #{response['Set-Cookie'].inspect}"
        @session = response['Set-Cookie']
      end # if response['Set-Cookie']
      return response
    end # post()
  end # class API
end # module Sengled
