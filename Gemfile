source 'http://rubygems.org'

platforms :jruby do
  gem 'jruby-openssl', '~> 0.7'
end

gem 'rack-openid', :github => 'david50407/rack-openid'
gem 'ruby-openid'

gemspec

group :development, :test do
  gem 'guard'
  gem 'guard-rspec'
  gem 'growl'
  gem 'rb-fsevent'
end

group :example do
  gem 'sinatra'
end