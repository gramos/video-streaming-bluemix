require 'oauth2'

@client = OAuth2::Client.new('a133e9d281add2e307588efa51027e3942560326',
                             'c8bcec38d6de2239b0a34c9ae63c956251c448f0',
                             :site => 'https://www.ustream.tv',
                             :token_url => '/oauth2/authorize')

#@token = @client.password.get_token('space-e75fe057-5746-4bec-bf37-7b82efae4c86', 'Perico123456')
# @client.auth_code.authorize_url(:redirect_uri => 'https://www.ustream.tv/oauth2/redirect')




#@token = client.auth_code.get_token('authorization_code_value',
#                                    :redirect_uri => 'http://localhost:8080/oauth2/callback',
#                                   :headers => {'Authorization' => 'Basic some_password'})

#response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
#response.class.name

