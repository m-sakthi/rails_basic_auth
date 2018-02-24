class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :account_activation]
  load_and_authorize_resource only: [:update, :show, :block, :activate, :destroy]

  authorize_resource only: [:index, :profile]

  swagger_controller :users, "User Management"

  swagger_api :index do
    summary 'Lists all User'
    param_list :query, :status, :string, :optional, 'Status', User::Status::ALL
    param :query, :limit, :integer, :optional, 'Number of users per page'
    param :query, :page_number, :integer, :optional, 'Page Number'
    response :ok
    response :unauthorized
    response :forbidden
  end

  def index
    if params[:status].present?
      @users = User.send(params[:status].to_sym)
    else
      @users = User.all
    end
    @users.page(params[:page_number]).per(params[:limit])
  end

  swagger_api :create do
    summary 'Create a new user'
    param :form, :'user[email]', :string, :required, "Email: maximum: 255 chars"
    param :form, :'user[password]', :string, :required, 'Password: maximum: 6 & maximum: 50 chars '
    param :form, :'user[password_confirmation]', :string, :required, 'Password Confirmation'
    param :form, :'user[first_name]', :string, :required, "First name: maximum: 50"
    param :form, :'user[last_name]', :string, :required, "Last name: maximum: 50"
    param :form, :'user[user_name]', :string, :optional, "User name(can be used to @ mention)"
    response :created
    response :bad_request
    response :forbidden
    response :not_acceptable
    response :unauthorized
  end

  def create
    @user = User.create(create_params)
    if @user.errors.present?
      render_model_errors(@user)
    else
      @user.send_activation_email
      render 'show', status: :created
    end
  end

  swagger_api :profile do
    summary 'Current User''s Profile'
    response :ok
  end

  def profile
    @user = current_user
    render 'show', status: :ok
  end

  swagger_api :update do
    summary 'Update a user'
    param :path, :id, :integer, :required, 'User ID'
    param :form, :'user[email]', :string, :optional, "Email: maximum: 255 chars"
    param :form, :'user[first_name]', :string, :optional, "First name: maximum: 50"
    param :form, :'user[last_name]', :string, :optional, "Last name: maximum: 50"
    param :form, :'user[user_name]', :string, :optional, "User name(can be used to @ mention)"
    param_list :form, :'user[status]', :string, :optional, "Status", User::Status::ALL
    response :created
    response :bad_request
    response :forbidden
    response :not_acceptable
    response :unauthorized
  end

  def update
    @user.update(update_params)
    if @user.errors.present?
      render_model_errors(@user)
    else
      render 'show', status: :ok
    end
  end

  swagger_api :account_activation do
    summary 'Display a users details'
    param :path, :token, :integer, :required, 'Token'
    param :query, :email, :integer, :required, 'Email ID'
    response :ok
    response :bad_request
    response :forbidden
    response :unauthorized
  end

  def account_activation
    @user = User.find_by(email: params[:email])
    if @user && !@user.active?
      if @user.authenticated?(:activation, params[:token])
        @user.active!
        render :show, status: :ok
      else
        render json: { error: _('views.users.email_token_does_not_match') }, status: :bad_request
      end
    else
      render json: { error: _('views.users.account_already_activated', email: params[:email]) }, status: :bad_request
    end
  end

  swagger_api :show do
    summary 'Display a users details'
    param :path, :id, :integer, :required, 'User ID'
    response :ok
    response :bad_request
    response :forbidden
    response :unauthorized
  end

  def show
  end

  swagger_api :destroy do
    summary 'Deletes the user'
    param :path, :id, :integer, :required, 'User ID'
    response :ok
    response :bad_request
    response :forbidden
    response :unauthorized
  end

  def destroy
    @user.destroy
    head :ok
  end

  private
    def create_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end

    def update_params
      params.require(:user).permit(:email, :first_name, :last_name, :status)
    end
end
