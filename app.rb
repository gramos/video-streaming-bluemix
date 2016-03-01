require 'cuba'
require 'mote'
require 'mote/render'
require 'net/http'

Cuba.plugin Mote::Render

# ----------------------------------------------------------------
# Load settings and config var in ENV.
#
module Settings
  File.read("env.sh").scan(/(.*?)="?(.*)"?$/).each do |key, value|
    ENV[key] ||= value
  end
end

Cuba.define do
  on root do

    on get do
      render 'index', client_id: ENV['CLIENT_ID'], redirect_uri: ENV['REDIRECT_URI']
    end

    on post do

      on param('video') do |video|
        uri = URI.parse('https://api.ustream.tv/channels/22083914/uploads.json?type=videoupload-ftp')
        https         = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        req = Net::HTTP::Post.new uri.path,
                                  {'Authorization' => "Bearer #{video['access_token']}" }

      end

    end
  end
end
