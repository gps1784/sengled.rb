require 'test_helper'

require 'json'
require 'net/http'

module Sengled::Fixtures
  module API
    module Login
      def get_login_valid_body()
        return File.read( File.join(__dir__, "login_valid_body.json") )
      end # get_login_valid_body()

      def get_login_valid_header()
        return JSON.parse( File.read( File.join(__dir__, "login_valid_header.json") ) )
      end # get_login_valid_body()

      def stub_http_start_with_valid_response(host, port, o)
        http = Net::HTTP.new('localhost')
        http.stub(:request, nil) {
          yield(http)
        }
        response = Net::HTTPResponse.new(1.0, 200, "OK")
        response.body = get_login_valid_body()
        response.instance_variable_set(:@header, get_login_valid_header())
        return response
      end # stub_http_start_with_valid_response()
    end # module Login
  end # module API
end # module Sengled::Fixtures
