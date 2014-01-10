require 'spec_helper'
require 'rack/openid'
require 'omniauth-ncu-portal-openid'

describe OmniAuth::Strategies::NCUPortalOpenID, :type => :strategy do
  def app
    strat = OmniAuth::Strategies::NCUPortalOpenID
    Rack::Builder.new {
      use Rack::Session::Cookie
      use strat
      run lambda {|env| [404, {'Content-Type' => 'text/plain'}, [nil || env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  def expired_query_string
    'openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.op_endpoint=https%3A%2F%2Fportal.ncu.edu.tw%2Fendpoint&openid.claimed_id=https%3A%2F%2Fportal.ncu.edu.tw%2Fuser%2F102000000&openid.response_nonce=2014-01-09T18%3A53%3A50Z0&openid.mode=id_res&openid.identity=https%3A%2F%2Fportal.ncu.edu.tw%2Fuser%2F102000000&openid.return_to=localhost&openid.assoc_handle=1378875396754-313310&openid.signed=op_endpoint%2Cclaimed_id%2Cidentity%2Creturn_to%2Cresponse_nonce%2Cassoc_handle%2Cns.ext1%2Cext1.mode%2Cext1.type.user_roles%2Cext1.value.user_roles%2Cext1.type.student_id%2Cext1.value.student_id&openid.sig=B7%2ButqAIcWXmVCHP%2FeleT7pgTklLygOl9lTxjN1tw9w%3D&openid.ns.ext1=http%3A%2F%2Fopenid.net%2Fsrv%2Fax%2F1.0&openid.ext1.mode=fetch_response&openid.ext1.type.user_roles=http%3A%2F%2Faxschema.org%2Fuser%2Froles&openid.ext1.value.user_roles=%5B%22ROLE_USER%22%2C%22ROLE_STUDENT%22%2C%22ROLE_LDAP%22%2C%22ROLE_ANY_STUDENT%22%5D&openid.ext1.type.student_id=http%3A%2F%2Faxschema.org%2Fstudent%2Fid&openid.ext1.value.student_id=102000000'
  end

  describe '/auth/ncu_portal_open_id without an identifier URL' do
    before do
      get '/auth/ncu_portal_open_id'
    end

    it 'should respond with OK' do
      last_response.should be_ok
    end

    it 'should respond with HTML' do
      last_response.content_type.should == 'text/html'
    end

    it 'should render an identifier URL input' do
      last_response.body.should =~ %r{<input[^>]*openid_url}
    end
  end

  #describe '/auth/open_id with an identifier URL' do
  #  context 'successful' do
  #    before do
  #      @identifier_url = 'http://me.example.org'
  #      # TODO: change this mock to actually return some sort of OpenID response
  #      stub_request(:get, @identifier_url)
  #      get '/auth/open_id?openid_url=' + @identifier_url
  #    end
  #
  #    it 'should redirect to the OpenID identity URL' do
  #      last_response.should be_redirect
  #      last_response.headers['Location'].should =~ %r{^#{@identifier_url}.*}
  #    end
  #
  #    it 'should tell the OpenID server to return to the callback URL' do
  #      return_to = CGI.escape(last_request.url + '/callback')
  #      last_response.headers['Location'].should =~ %r{[\?&]openid.return_to=#{return_to}}
  #    end
  #  end
  #end

  describe 'followed by /auth/open_id/callback' do
    context 'successful' do
      #before do
      #  @identifier_url = 'http://me.example.org'
      #  # TODO: change this mock to actually return some sort of OpenID response
      #  stub_request(:get, @identifier_url)
      #  get '/auth/open_id/callback'
      #end

      it "should set provider to open_id"
      it "should create auth_hash based on sreg"
      it "should create auth_hash based on ax"

      #it 'should call through to the master app' do
      #  last_response.body.should == 'true'
      #end
    end

    context 'unsuccessful' do
      describe 'returning with expired credentials' do
        before do
          # get '/auth/open_id/callback?' + expired_query_string
        end

        it 'it should redirect to invalid credentials' do
          pending
          last_response.should be_redirect
          last_response.headers['Location'].should =~ %r{invalid_credentials}
        end
      end
    end
  end

end