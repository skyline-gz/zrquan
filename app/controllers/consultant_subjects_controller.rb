class ConsultantSubjectsController < ApplicationController
  before_action :set_consultant_subject, only: [:show, :edit, :update, :destroy]

  # GET /consultant_subjects
  # GET /consultant_subjects.json
  def index
    @consultant_subjects = ConsultantSubject.all
  end

  # GET /consultant_subjects/1
  # GET /consultant_subjects/1.json
  def show
  end

  # GET /consultant_subjects/new
  def new
    @consultant_subject = ConsultantSubject.new
  end

  # GET /consultant_subjects/1/edit
  def edit
  end

  # POST /consultant_subjects
  # POST /consultant_subjects.json
  def create
    @consultant_subject = ConsultantSubject.new(consultant_subject_params)

    respond_to do |format|
      if @consultant_subject.save
        format.html { redirect_to @consultant_subject, notice: 'Consultant subject was successfully created.' }
        format.json { render :show, status: :created, location: @consultant_subject }
      else
        format.html { render :new }
        format.json { render json: @consultant_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consultant_subjects/1
  # PATCH/PUT /consultant_subjects/1.json
  def update
    respond_to do |format|
      if @consultant_subject.update(consultant_subject_params)
        format.html { redirect_to @consultant_subject, notice: 'Consultant subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @consultant_subject }
      else
        format.html { render :edit }
        format.json { render json: @consultant_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consultant_subjects/1
  # DELETE /consultant_subjects/1.json
  def destroy
    @consultant_subject.destroy
    respond_to do |format|
      format.html { redirect_to consultant_subjects_url, notice: 'Consultant subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consultant_subject
      @consultant_subject = ConsultantSubject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consultant_subject_params
      params.require(:consultant_subject).permit(:title, :content, :theme_id, :mentor_id, :apprentice_id, :mentor_stat_flag, :user_stat_flag)
    end
end
