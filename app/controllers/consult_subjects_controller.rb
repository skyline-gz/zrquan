class ConsultSubjectsController < ApplicationController
  before_action :set_consult_subject, only: [:show, :edit, :update, :destroy]

  # GET /consult_subjects
  # GET /consult_subjects.json
  def index
    @consult_subjects = ConsultSubject.all
  end

  # GET /consult_subjects/1
  # GET /consult_subjects/1.json
  def show
  end

  # GET /consult_subjects/new
  def new
    @consult_subject = ConsultSubject.new
  end

  # GET /consult_subjects/1/edit
  def edit
  end

  # POST /consult_subjects
  # POST /consult_subjects.json
  def create
    @consult_subject = ConsultSubject.new(consult_subject_params)

    respond_to do |format|
      if @consult_subject.save
        format.html { redirect_to @consult_subject, notice: 'Consult subject was successfully created.' }
        format.json { render :show, status: :created, location: @consult_subject }
      else
        format.html { render :new }
        format.json { render json: @consult_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consult_subjects/1
  # PATCH/PUT /consult_subjects/1.json
  def update
    respond_to do |format|
      if @consult_subject.update(consult_subject_params)
        format.html { redirect_to @consult_subject, notice: 'Consult subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @consult_subject }
      else
        format.html { render :edit }
        format.json { render json: @consult_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consult_subjects/1
  # DELETE /consult_subjects/1.json
  #def destroy
  #  @consult_subject.destroy
  #  respond_to do |format|
  #    format.html { redirect_to consult_subjects_url, notice: 'Consult subject was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consult_subject
      @consult_subject = ConsultSubject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consult_subject_params
      params.require(:consult_subject).permit(:title, :content, :theme_id, :mentor_id, :apprentice_id, :mentor_stat_flag, :user_stat_flag)
    end
end
