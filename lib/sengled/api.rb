require 'json'
require 'net/http'
require 'net/https'
require 'pp'

require 'colorized_string'

require 'sengled/device'

module Sengled
  class API

    SENGLED_URL = "https://element.cloud.sengled.com/zigbee/"

    def initialize(username:, password:, session: nil)
      @devices  = nil
      @session  = session # data from 'cookie'/'set-cookie'
      puts inspect()
      login(username: username, password: password)
    end # initialize()

    def inspect()
      str = "#<#{self.class.name}: "
      if( @session )
        str << ColorizedString["@session:ACTIVE"].black.on_green
      else
        str << ColorizedString["@session:INACTIVE"].white.on_red
      end
      str << ">"
    end # inspect()

    def login(username:, password:, force: false)
      if( !@session || force )
        response = post(path: "customer/login.json",
          # parameters of post
          "os_type": "android",
          "user": username,
          "pwd": password,
          "uuid": "xxxx"
        )
      end # if @seesion && !force
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
          Sengled::Device.new(dev)
        end
        #pp devices_raw, @devices
        pp @devices
      end
      return @devices
    end # get_device_details()

    alias :get_devices :get_device_details
    alias :devices     :get_device_details

    private
    def post(path:, use_ssl: true, root_path: nil, **body)
      root_path ||= SENGLED_URL
      url = URI.parse(root_path + path)
      response = Net::HTTP.start(url.host, url.port, use_ssl: use_ssl) do |https|
        request = Net::HTTP::Post.new(url)
        if( @session )
          request['Cookie'] = @session
        end
        request['Content-Type'] = 'application/json'
        request.body            = body.to_json
        https.request(request)
      end # Net::HTTP.start()
      @session = response['Set-Cookie']
      #puts response.to_hash.inspect, response.body
      return response
    end # post()
  end # class API
end # module Sengled
