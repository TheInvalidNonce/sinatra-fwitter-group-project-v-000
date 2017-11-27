class UserController < ApplicationController

  # If not logged_in? Load Signup form, else load user tweets page #
  get '/signup' do
    if !logged_in?
      erb :'/users/create_user'
    else
      redirect '/tweets'
    end
  end

  # If: any empty fields => load /signup again. Else: Create the user with params, assign session[:user_id] to user, load /tweets #
  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect '/signup'
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect '/tweets'
    end
  end

  # If logged_in? redirect to /tweets, otherwise redirect to /login #
  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end

  # Find user by username, if exists && password is authenticated, assign session[:user_id] to user, load /tweets. Else: load /login #
  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  # Find user by slugified name, display show page #
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

  # If logged_in?: Logout, redirect to /login. Else redirect to / #
  get '/logout' do
    if logged_in?
      logout!
      redirect '/login'
    else
      redirect '/'
    end
  end




end
