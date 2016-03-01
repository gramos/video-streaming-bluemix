require 'cuba'
require 'mote'
require 'mote/render'
require 'net/http'
require 'net/https'
require 'json'

Cuba.plugin Mote::Render

# ----------------------------------------------------------------
# Load settings and config var in ENV.
#
module Settings
  File.read("env.sh").scan(/(.*?)="?(.*)"?$/).each do |key, value|
    ENV[key] ||= value
  end
end

require 'net/ftp'

class Upload
  attr_reader :p

  def initialize(params, file_path)
    @p        = JSON.parse(params)

    Net::FTP.open( @p['host'], @p['user'], @p['password'] ) do |ftp|
      ftp.put file_path, File.basename(file_path)
    end
  end
end

Cuba.define do
  on root do

    on get do
      render 'index', client_id: ENV['CLIENT_ID'], redirect_uri: ENV['REDIRECT_URL']
    end

    on post do
      on param('video') do |video|
        uri_str = 'https://api.ustream.tv/channels/22083914/uploads.json?type=videoupload-ftp'

        uri               = URI.parse uri_str
        https             = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl     = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new uri,
                                  {'Authorization' => "Bearer #{video['access_token']}"}

        request.set_form_data({"title" => "quentin"})
        response = https.request(request)

        upload = Upload.new response.body, req['video']['file'][:tempfile].path

        uri_str = "https://api.ustream.tv/channels/22083914/uploads/#{upload.p['videoId']}.json"

        uri               = URI.parse uri_str
        https             = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl     = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Put.new uri,
                                  {'Authorization' => "Bearer #{video['access_token']}"}

        request.set_form_data({"status" => "ready"})
        response = https.request(request)
        puts upload.p['videoId'].inspect
        puts response.inspect
      end

    end
  end
end
