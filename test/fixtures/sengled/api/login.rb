require 'test_helper'

require 'json'
require 'net/http'

module Sengled::Fixtures
  module API
    module Login
      def get_login_good_01_body()
        return File.read( File.join(__dir__, "login_good_01_body.json") )
      end # get_login_good_01_body()

      def get_login_good_01_header()
        return JSON.parse( File.read( File.join(__dir__, "login_good_01_header.json") ) )
      end # get_login_good_01_body()

      # step 1) create a bogus HTTP connection for the API
      # step 2) stub Net::HTTP#request to a do-nothing dummy
      # step 3) return a bogus HTTPResponse that looks like #<HTTPOK>
      def http_start_stub_good_01(host, port, o)
        http = Net::HTTP.new('localhost')
        http.stub(:request, nil) do
          yield(http)
        end # http.stub(:request)
        response = Net::HTTPResponse.new(1.0, 200, "OK")
        response.body = get_login_good_01_body()
        response.instance_variable_set(:@header, get_login_good_01_header())
        return response
      end # http_start_stub_good_01()

      # this does a few things, including preventing unwanted network traffic.
      # that Net::HTTP stub is a hassle to write every time I want this stub,
      # which is basically for every API test. since I don't want to spam their
      # server, we mask Net::HTTP.start and replace it with a stub that
      # generates a fake HTTPResponse and turns Net::HTTP#request into a dummy
      def stub_http_start_with_good_01_response()
        Net::HTTP.stub(:start, method(:http_start_stub_good_01)) do
          yield()
        end # Net::HTTP.stub(:start)
      end # stub_http_start_with_good_01_response()
    end # module Login
  end # module API
end # module Sengled::Fixtures
