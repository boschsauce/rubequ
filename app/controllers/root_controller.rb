require 'reloader/sse'

class RootController < ApplicationController
  include ActionController::Live

  def index
  end

  def connected
    mpd = RubequMpd::Mpd.new
    connected = mpd.connected?
    mpd.disconnect
    respond_to do |format|
      format.json { render :json => connected }
    end
  end

  def volume
    mpd = RubequMpd::Mpd.new
    volume = mpd.volume
    mpd.disconnect
    respond_to do |format|
      format.json { render :json => volume }
    end
  end

  def volume_live
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::SSE.new(response.stream)
    mpd = RubequMpd::Mpd.new
    begin
      a = Thread.new {
        mpd.mpd.on(:volume) do |volume|
          sse.write({ :volume => volume}, :event => 'refresh')
        end
      }
      sleep 0.1 while a.status!='sleep'
      a.run
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end

  def update_volume
    mpd = RubequMpd::Mpd.new
    volume = mpd.volume(params[:volume])
    mpd.disconnect
    respond_to do |format|
      format.json { render :json => volume }
    end
  end
end
