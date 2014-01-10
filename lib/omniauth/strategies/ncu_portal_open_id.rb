require 'omniauth'
require 'rack/openid'
require 'openid/store/memory'

module OmniAuth
  module Strategies
    # OmniAuth strategy for connecting via NCU Portal OpenID.
    class NCUPortalOpenID
      include OmniAuth::Strategy

      AX = {
        :user_roles => 'http://axschema.org/user/roles',

        :contact_email => 'http://axschema.org/contact/email',
        :contact_name => 'http://axschema.org/contact/name',
        :contact_ename => 'http://axschema.org/contact/ename',
        :student_id => 'http://axschema.org/student/id',
        :alunmi_leaveSem => 'http://axschema.org/alunmi/leaveSem'
      }
      option :name, :ncu_portal_open_id
      option :required, ["user_roles=#{AX[:user_roles]}"]
      option :optional, AX.reject { |k, v|
        k == :user_roles
      }.to_a.map { |ax|
        "#{ax[0].to_s}=#{ax[1]}"
      }
      option :store, ::OpenID::Store::Memory.new
      option :identifier, 'http://portal.ncu.edu.tw/user/'
      option :identifier_param, 'openid_url'

      def dummy_app
        lambda{|env| [401, {"WWW-Authenticate" => Rack::OpenID.build_header(
          :identifier => identifier,
          :return_to => callback_url,
          :required => options.required,
          :optional => options.optional,
          :method => 'post'
        )}, []]}
      end

      def identifier
        i = options.identifier || request.params[options.identifier_param.to_s]
        i = nil if i == ''
        i
      end

      def request_phase
        identifier ? start : get_identifier
      end

      def start
        openid = Rack::OpenID.new(dummy_app, options[:store])
        response = openid.call(env)
        case env['rack.openid.response']
        when Rack::OpenID::MissingResponse, Rack::OpenID::TimeoutResponse
          fail!(:connection_failed)
        else
          response
        end
      end

      def get_identifier
        f = OmniAuth::Form.new(:title => 'OpenID Authentication')
        f.label_field('OpenID Identifier', options.identifier_param)
        f.input_field('url', options.identifier_param)
        f.to_response
      end

      uid { openid_response.display_identifier }

      info do
        ax_user_info
      end

      extra do
        {'response' => openid_response}
      end

      def callback_phase
        return fail!(:invalid_credentials) unless openid_response && openid_response.status == :success
        super
      end

      def openid_response
        unless @openid_response
          openid = Rack::OpenID.new(lambda{|env| [200,{},[]]}, options[:store])
          openid.call(env)
          @openid_response = env.delete('rack.openid.response')
        end
        @openid_response
      end

      def sreg_user_info
        {}
      end

      def ax_user_info
        ax = ::OpenID::AX::FetchResponse.from_success_response(openid_response)
        return {} unless ax
        {
          :user_roles => ax.get(AX[:user_roles]),

          :email => ax.get_single(AX[:contact_email]),
          :name => ax.get_single(AX[:contact_name]),
          :ename => ax.get_single(AX[:contact_ename]),
          :student_id => ax.get_single(AX[:student_id]),
          :alunmi_leaveSem => ax.get_single(AX[:alunmi_leaveSem])
        }.inject({}){|h,(k,v)| h[k.to_s] = Array(v).first; h}.reject{|k,v| v.nil? || v == ''}
      end
    end
  end
end

OmniAuth.config.add_camelization 'ncuportalopenid', 'NCUPortalOpenID'
OmniAuth.config.add_camelization 'ncu_portal_open_id', 'NCUPortalOpenID'