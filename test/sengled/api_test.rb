require "test_helper"

require "fixtures/sengled/api/login"

module Sengled::Test
  class API < Minitest::Test
    include Sengled::Fixtures::API::Login

    def test_post_should_set_cookie()
      Net::HTTP.stub(:start, method(:stub_http_start_with_valid_response)) do
        interface = Sengled::API.new(skip_login: true)
        assert_nil(interface.instance_variable_get(:@session))
        interface.login(username: 'oingo', password: 'boingo')
        refute_nil(interface.instance_variable_get(:@session))
      end # Net::HTTP.stub
    end
  end # class API
end # module Sengled::Test
