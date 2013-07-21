class RootController < ApplicationController
  def index
  end

  def connected
    mpd = RasplayMpd::Mpd.new
    connected = mpd.connected?
    mpd.disconnect
    respond_to do |format|
      format.json { render :json => connected } 
    end
  end
end
