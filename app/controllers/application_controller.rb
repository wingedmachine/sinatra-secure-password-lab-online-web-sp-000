require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username]&.length > 0 \
      && User.new(username: params[:username], password: params[:password]).save

      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    session[:user_id] = User.find_by(username: params[:username]) \
      .authenticate(params[:password])
      
    erb :login
  end

  post "/login" do
    if params[:username]&.length > 0 && params[:password]&.length > 0
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
