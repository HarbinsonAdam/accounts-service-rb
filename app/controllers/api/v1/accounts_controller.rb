class Api::V1::AccountsController < Api::ApiController
  before_action :set_user, only: [:show, :update, :destroy]
 
  # GET /accounts
  def index
    render json: users
  end
 
  # GET /accounts/:id
  def show
		if user
    	render json: {success: true, data: present_user}
		else
			render json: {success: false, errors: "Account details could not be fetched"}
		end
  end
 
  # POST /accounts
  def create
    @user = User.new(user_params)
 
    if user.save
      render json: {success: true, data: present_user}, status: :created
    else
      render json: {success: false, errors: user.errors}, status: :unprocessable_entity
    end
  end
 
  # PATCH/PUT /accounts/:id
	def update
    if user.update(user_params)
      render json: {success: true, data: present_user}
    else
      render json: {success: false, errors: user.errors}, status: :unprocessable_entity
    end
  end
 
  # DELETE /accounts/:id
  def destroy
    user.destroy
    render status: :ok
  end
 
  attr_reader :user

  private

  def users
    @users ||= User.all
  end
 
  def set_user
    @user = User.find(params[:id])
  end
 
  def user_params
    params.permit(:first_name, :last_name, :dob, :password, :email)
  end

	def present_user
		{
			id: user.id,
			email: user.email,
			first_name: user.first_name,
			last_name: user.last_name,
			dob: user.dob,
		}
	end
end