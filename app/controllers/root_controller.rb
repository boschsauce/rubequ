require 'mpd'

class RootController < ApplicationController
  def index
  end

  def connected
    @mpd = Mpd.new("127.0.0.1")
    @mpd.connect
    connected = @mpd.connected?
    @mpd.disconnect
    respond_to do |format|
      format.json { render :json => connected } 
    end
  end
end
