class SongsController < ApplicationController
  before_action :set_song, only: [:show, :lyrics, :add_to_queue, :edit, :update, :destroy]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  def lyrics
    respond_to do |format|
      format.json {render json: @song.lyrics.to_json }
    end
  end

  def current_song
    @song = Song.current_song
    respond_to do |format|
      format.json  { render :json => @song }
    end
  end

  def songs_in_queue
    @songs = Song.all_in_queue
    respond_to do |format|
      format.json  { render :json => @songs }
    end
  end

  def add_to_queue
    respond_to do |format|
      if @song.add_to_queue
        format.json { render json: @song, status: :created }
      else
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def play
    Song.play
    @song = Song.current_song
    respond_to do |format|
      format.json  { render :json => @song }
    end
  end

  def pause
    Song.pause
    @song = Song.current_song
    respond_to do |format|
      format.json  { render :json => @song }
    end
  end

  def next
    Song.next
    @song = Song.current_song
    respond_to do |format|
      format.json  { render :json => @song }
    end
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.unscoped.new(song_params)
    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render action: 'show', status: :created, location: @song }
      else
        format.js   { render :template => 'songs/error' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.js   { render template: 'songs/update' } 
        format.json { head :no_content }
      else
        format.js   { render template: 'songs/error' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      song_id = params[:id].blank? ? params[:song_id] : params[:id]
      @song = Song.find(song_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :band, :album, :album_cover, :release_date, :mp3)
    end
end
