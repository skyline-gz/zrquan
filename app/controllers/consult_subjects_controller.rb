class ConsultSubjectsController < ApplicationController
  before_action :set_consult_subject, only: [:show, :edit, :update, :close, :accept, :ignore]
  before_action :authenticate_user!

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
		logger.debug("invoked consult_subjects new method.")
    @consult_subject = ConsultSubject.new
		@mentor = @consult_subject.build_mentor
		@mentor.first_name = params[:first_name]
		@mentor.last_name = params[:last_name]	
		@mentor.id = params[:id]
		logger.debug(@mentor.id)
  end

  # GET /consult_subjects/1/edit
  def edit
  end

  # POST /consult_subjects
  # POST /consult_subjects.json
  def create
    @consult_subject = ConsultSubject.new(consult_subject_params)
		@consult_subject.apprentice_id = current_user.id
		@consult_subject.mentor_id = mentor_params[:mentor_attributes][:id]
		@consult_subject.stat_class = 1		# applying
		@consult_subject.save!
		msg_content = "New consult apply " + @consult_subject.title + " to you."
		@consult_subject.mentor.messages.create!(content: msg_content, msg_type: 1)
		respond_to do |format|
			format.html { redirect_to @consult_subject, notice: 'Consult subject was successfully created.' }
	    format.json { render :show, status: :created, location: @consult_subject }
		end
  end

  # PATCH/PUT /consult_subjects/1
  # PATCH/PUT /consult_subjects/1.json
  def update
    @consult_subject.update_attributes!(consult_subject_params)
    respond_to do |format|
      format.html { redirect_to @consult_subject, notice: 'Consult subject was successfully updated.' }
      format.json { render :show, status: :ok, location: @consult_subject }
    end
  end

	# accept and apply of the consult subject
	def accept
		@consult_subject.update_attributes!(:stat_class=>2)
		msg_content = "Your consult apply " + @consult_subject.title + " has been accepted."
		@consult_subject.apprentice.messages.create!(content: msg_content, msg_type: 1)
		respond_to do |format|
			format.html { redirect_to consult_subjects_path, notice: 'Consult subject was successfully updated.' }
      format.json { render :show, status: :ok, location: @consult_subject }
		end
	end

	# close a processing consult
	def close
		logger.debug("invoked consult subject close")
		@consult_subject.update_attributes!(:stat_class=>3)
		msg_content = "Consult " + @consult_subject.title + " has been closed."
		@consult_subject.apprentice.messages.create!(content: msg_content, msg_type: 1)
		@consult_subject.mentor.messages.create!(content: msg_content, msg_type: 1)
		respond_to do |format|
			format.html { redirect_to consult_subjects_path, notice: 'Consult subject was successfully updated.' }
      format.json { render :show, status: :ok, location: @consult_subject }
		end
	end

	# ignore an applying consult subject
	def ignore
		logger.debug("invoked consult subject ignore")
		@consult_subject.update_attributes!(:stat_class=>4)
		respond_to do |format|
			format.html { redirect_to consult_subjects_path, notice: 'Consult subject was successfully updated.' }
      format.json { render :show, status: :ok, location: @consult_subject }
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
      params.require(:consult_subject).permit(:title, :content, :theme_id)
    end

		def mentor_params
      params.require(:consult_subject).permit(mentor_attributes:[:id])
    end

end
