class TweetController < ApplicationController

  # If: logged_in? @user = current_user, load users tweets. Else: redirect /login #
  get '/tweets' do
    if logged_in?
      @user = current_user
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect '/login'
    end
  end

  # New tweet action checks if logged_in?, if true, @user = current_user. Load create tweet form. Else: force /login page #
  get '/tweets/new' do
    if logged_in?
      @user = current_user
      erb :'/tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if !params[:content].empty? && logged_in?
      @tweet = current_user.tweets.create(content: params[:content])
      redirect "/tweets/#{@tweet.id}"
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by(id: params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in? && Tweet.find_by_id(params[:id]).user == current_user
      @tweet = Tweet.find_by_id(params[:id])
      erb :"/tweets/edit_tweet"
    elsif logged_in? && Tweet.find_by_id(params[:id]) != current_user
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    if logged_in? && !params[:content].empty?
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    else
      redirect "/tweets/#{params[:id]}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == current_user.id
        @tweet.delete
        redirect '/tweets'
      else
        redirect '/tweets'
      end
    else
      redirect '/login'
    end
  end

end
