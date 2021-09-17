class NotesController < ApplicationController
  before_action :set_note, only: [:update, :destroy]
  before_action :authorized, only: [:create, :update, :destroy, :notelist]

  # GET /notes
  def index
    @notes = Note.all #Note.where(user_id: @user.id)

    render json: @notes
  end

  #Related user's notes
  def notelist
    @notes = Note.where(user_id: @user.id)

    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.user_id = @user.id

    if @note.save
      render json: @note, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :user_id, :tags => [])
    end
end
