class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    puts user_params
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
    
  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation)}
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user].permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end  
end
