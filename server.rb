require 'sinatra'
require 'haml'
require 'httparty'

get '/' do
  haml :index
end

post '/' do
  @client_email = params[:email]

  HTTParty.post("https://api.box.com/2.0/folders/", 
    {
      :headers => { 'Authorization' => 'Bearer 9ap3MFMeWJcw2RE0X7cwSdWxJSpFk81P' },
      :body => { "name" => @client_email, "parent" => {"id" => "0"} }.to_json
    })
  
  redirect '/collaborate'
end

get '/collaborate' do
  haml :collaborate
end

post '/collaborate' do
  redirect '/create'
end 

get '/create' do
  haml :create
end