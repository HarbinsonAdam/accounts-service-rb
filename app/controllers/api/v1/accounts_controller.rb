class Api::V1::AccountsController < Api::ApiController
  before_action :set_user, only: [:show, :update, :destroy]
 
  # GET /accounts
  def index
     @users = User.all
     render json: @users
  end
 
  # GET /accounts/:id
  def show
     render json: user
  end
 
  # POST /accounts
  def create
     @user = User.new(user_params)
 
     if user.save
       render json: user, status: :created
     else
       render json: user.errors, status: :unprocessable_entity
     end
  end
 
  # PATCH/PUT /accounts/:id
  def update
     if user.update(user_params)
       render json: user
     else
       render json: user.errors, status: :unprocessable_entity
     end
  end
 
  # DELETE /accounts/:id
  def destroy
     user.destroy
     render status: :ok
  end

  attr_reader :user
 
  private
 
  def set_user
     @user = User.find(params[:id])
  end
 
  def user_params
     params.permit(:first_name, :last_name, :dob, :password, :email)
  end
end