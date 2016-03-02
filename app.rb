require 'cuba'
require 'mote'
require 'mote/render'
require 'net/http'
require 'net/https'
require 'json'
require 'net/ftp'

Cuba.plugin Mote::Render
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"

# ----------------------------------------------------------------
# Load settings and config var in ENV.
#
module Settings
  File.read("env.sh").scan(/(.*?)="?(.*)"?$/).each do |key, value|
    ENV[key] ||= value
  end
end

class Upload
  attr_reader :p

  def initialize(access_token)
    @access_token = access_token
  end

  def make!(file, title)
    @file  = file
    @title = title

    request = make_request 'uploads.json?type=videoupload-ftp', Net::HTTP::Post
    @p      = JSON.parse(request.body)

    Net::FTP.open( @p['host'], @p['user'], @p['password'] ) do |ftp|
      ftp.debug_mode = true
      ftp.putbinaryfile @file, @p['path']
    end

    puts @p['url']
    #make_request "uploads/#{@p['videoId']}.json", Net::HTTP::Put
  end

  def make_request(path, method)
    uri_str = "https://api.ustream.tv/channels/22083914/#{path}"

    uri               = URI.parse uri_str
    https             = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl     = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request  = method.new uri, {'Authorization' => "Bearer #{@access_token}"}

    if method == Net::HTTP::Put
      request.set_form_data({"status" => "ready"})
    else
      request.set_form_data({"title" => @title})
    end

    response = https.request(request)
  end
end

Cuba.define do
  on root do

    on get do
      puts req.session.inspect

      if req.params['access_token']
        req.session[:access_token] = req.params['access_token']
      end

      puts req.session.inspect
      render 'index', client_id: ENV['CLIENT_ID'], redirect_uri: ENV['REDIRECT_URL']
    end

    on post do
      on param('video') do |video|
        file_path = req['video']['file'][:tempfile] #.path
        upload    = Upload.new video['access_token']
        upload.make! file_path, req['video']['title']
      end

    end
  end
end
