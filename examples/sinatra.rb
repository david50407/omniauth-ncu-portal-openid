require 'rubygems'
require 'bundler'
require 'logger'

Bundler.setup :default, :development, :example
require 'sinatra'
require 'omniauth-ncu-portal-openid'
require 'openid/store/filesystem'

set :sessions, true
set :logging, true
set :environment, :production
$log = Logger.new('log/login.txt', 'weekly')

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :ncu_portal_open_id #, store: OpenID::Store::Filesystem.new('/tmp')
end

get '/' do
  <<-HTML
  <ul>
    <li><a href='/auth/ncu_portal_open_id'>Sign in with NCU Portal</a></li>
  </ul>
  HTML
end

[:get, :post].each do |method|
  send method, '/auth/:provider/callback' do
    content_type 'text/plain'
    $log.info request.env['omniauth.auth'].info.to_hash.to_s
    "Hi, #{request.env['omniauth.auth'].info[:student_id].to_s}. Thanks for test. <(_ _)>"
  end
end
