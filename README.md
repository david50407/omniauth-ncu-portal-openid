# OmniAuth::NCUPortalOpenID

Provides strategies for authenticating to providers using the OpenID (NCU Portal featured).

## Installation

    gem omniauth-ncu-portal-openid, :github => 'david50407/omniauth-ncu-portal-openid'

## Stand-Alone Example

Use the strategy as a middleware in your application:

    require 'omniauth-ncu-portal-openid'
    require 'openid/store/filesystem'

    use Rack::Session::Cookie
    use OmniAuth::Strategies::NCUPortalOpenID, :store => NCUPortalOpenID::Store::Filesystem.new('/tmp')

Then simply direct users to `/auth/ncu_portal_open_id` to prompt them for their NCU Portal OpenID identifier. You may also pre-set the identifier by passing an `identifier` parameter to the URL (Example: `/auth/ncu_portal_open_id?openid_url=yahoo.com`).

## OmniAuth Builder

If OpenID is one of several authentication strategies, use the OmniAuth Builder:

    require 'omniauth-ncu-portal-openid'
    require 'openid/store/filesystem'

    use OmniAuth::Builder do
      provider :ncu_portal_open_id, :store => NCUPortalOpenID::Store::Filesystem.new('/tmp')
    end

Note the use of nil, which will trigger ruby-openid's default Memory Store.

## License

Copyright (c) 2014 David Kuo <me@davy.tw>
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
