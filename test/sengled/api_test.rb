require 'test_helper'

require 'sengled/api'
require 'sengled/errors'

require 'fixtures/sengled/api/login'

module Sengled::Test
  class API < Minitest::Test
    include Sengled::Fixtures::API::Login

    def test_new_should_start_a_session()
      stub_http_start_with_good_01_response() do
        interface = Sengled::API.new(username: 'oingo', password: 'boingo')
        refute_nil(interface.instance_variable_get(:@session))
      end # stub_http_start_with_good_01_response()
    end

    def test_must_include_session_or_username_and_password_or_skip_login()
      stub_http_start_with_good_01_response() do
        assert_raises(Sengled::API::APIError) { Sengled::API.new() }
        assert_raises(Sengled::API::APIError) { Sengled::API.new(username: 'oingo') }
        assert_raises(Sengled::API::APIError) { Sengled::API.new(password: 'boingo') }
        assert( Sengled::API.new(username: 'oingo', password: 'boingo') )
        assert( Sengled::API.new(session: 'DUMMY_SESSION') )
        assert( Sengled::API.new(skip_login: true) )
      end # stub_http_start_with_good_01_response()
    end

    def test_login_should_change_inspect()
      stub_http_start_with_good_01_response() do
        interface = Sengled::API.new(skip_login: true)
        assert_match(/@session:INACTIVE/, interface.inspect())
        interface.login(username: 'oingo', password: 'boingo')
        assert_match(/@session:ACTIVE/, interface.inspect())
      end # stub_http_start_with_good_01_response()
    end

    def test_post_should_set_cookie()
      stub_http_start_with_good_01_response() do
        interface = Sengled::API.new(skip_login: true)
        assert_nil(interface.instance_variable_get(:@session))
        interface.login(username: 'oingo', password: 'boingo')
        refute_nil(interface.instance_variable_get(:@session))
      end # stub_http_start_with_good_01_response()
    end
  end # class API
end # module Sengled::Test
