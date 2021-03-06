class TweetsController < ApplicationController

  get '/tweets' do
   if logged_in?
     @tweets = Tweet.all
     erb :'/tweets/tweets'
   else
     redirect to '/login'
   end
 end

 get '/tweets/new' do
   if !logged_in?
     redirect to '/login'
   else
     erb :'/tweets/create_tweet'
   end
  end


  post '/tweets' do
      @tweet = current_user.tweets.create(content: params[:content])
      #current_user.tweets << @tweet
      redirect to "/tweets/#{@tweet.id}"
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == current_user.id
       erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in?
      tweet = current_user.tweets.find_by(id: params[:id])
      if tweet && tweet.destroy
        redirect to '/tweets'
      else
        redirect to '/tweets/#{tweet.id}'
      end
    else
      redirect to '/login'
    end
  end
end
