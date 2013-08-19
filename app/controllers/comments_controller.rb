class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :set_song,    only: [:index, :new, :create, :destroy]

  def index
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        @song.comments << @comment
        format.js   { render :template => 'comments/create' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.js   { render :template => 'comments/error' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to song_url @song }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:song_id])
    end

    def set_comment
      comment_id = params[:id].blank? ? params[:comment_id] : params[:id]
      @comment = Comment.find(comment_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:comment_text)
    end
end
