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
		logger.debug("invoked consult_subjects create method.")
		logger.debug(mentor_params[:mentor_attributes])
    @consult_subject = ConsultSubject.new(consult_subject_params)
		logger.debug(consult_subject_params)
		@consult_subject.apprentice_id = current_user.id
		@consult_subject.mentor_id = mentor_params[:mentor_attributes][:id]
		@consult_subject.stat_class = 1		# applying

		begin
			ActiveRecord::Base.transaction do
				@consult_subject.save!
				msg_content = "New consult apply " + @consult_subject.title + " to you."
				create_message(msg_content, 1, @consult_subject.mentor_id)
			end
			respond_to do |format|
				format.html { redirect_to @consult_subject, notice: 'Consult subject was successfully created.' }
		    format.json { render :show, status: :created, location: @consult_subject }
			end
		rescue => e
			respond_to do |format|
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

	# accept and apply of the consult subject
	def accept
		begin
			ActiveRecord::Base.transaction do
				@consult_subject.update_attributes!(:stat_class=>2)
				msg_content = "Your consult apply " + @consult_subject.title + " has been accepted."
				create_message(msg_content, 1, @consult_subject.apprentice_id)
			end
			respond_to do |format|
				format.html { redirect_to consult_subjects_path, notice: 'Consult subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @consult_subject }
			end
		rescue => e
			respond_to do |format|
				format.html { render :new }
        format.json { render json: @consult_subject.errors, status: :unprocessable_entity }
			end
		end
	end

	# close a processing consult
	def close
		begin
			ActiveRecord::Base.transaction do
				logger.debug("invoked consult subject close")
				@consult_subject.update_attributes!(:stat_class=>3)
				msg_content = "Consult " + @consult_subject.title + " has been closed."
				create_message(msg_content, 1, @consult_subject.apprentice_id)
				create_message(msg_content, 1, @consult_subject.mentor_id)
			end
			respond_to do |format|
				format.html { redirect_to consult_subjects_path, notice: 'Consult subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @consult_subject }
			end
		rescue => e
			respond_to do |format|
				format.html { render :new }
        format.json { render json: @consult_subject.errors, status: :unprocessable_entity }
			end
		end	
	end

	# ignore an applying consult subject
	def ignore
		begin
			ActiveRecord::Base.transaction do
				logger.debug("invoked consult subject ignore")
				@consult_subject.update_attributes!(:stat_class=>4)
			end
			respond_to do |format|
				format.html { redirect_to consult_subjects_path, notice: 'Consult subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @consult_subject }
			end
		rescue => e
			respond_to do |format|
				format.html { render :new }
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
      params.require(:consult_subject).permit(:title, :content, :theme_id)
    end

		def mentor_params
      params.require(:consult_subject).permit(mentor_attributes:[:id])
    end

		def create_message(content, msg_type, user_id)
			@message = Message.new
			@message.content = content
			@message.msg_type = msg_type 	#fake type
			@message.user_id = user_id
			@message.save!
		end
end
