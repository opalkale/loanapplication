require 'sinatra'
require 'haml'
require 'httparty'

get '/' do
  haml :index
end

post '/' do
  @client_email = params[:email]

  query   = { "name" => @client_email, "parent" => {"id" => "0"} }
  headers = { "Authorization"=> "Bearer 9ap3MFMeWJcw2RE0X7cwSdWxJSpFk81P" }
  HTTParty.post("https://api.box.com/2.0/folders/", :query => query, :headers => headers)

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