require 'sinatra'
require 'haml'
require 'httparty'
require 'pony'
require 'json'

get '/' do
  haml :index
end

post '/' do
  @client_email = params[:email]

  response = HTTParty.post("https://api.box.com/2.0/folders/", 
    {
      :headers => { 'Authorization' => 'Bearer q0v26fI8OaFu7RMEzmOv0dz4jGRK2wzz' },
      :body => { "name" => @client_email, "parent" => {"id" => "0"} }.to_json
    })

  puts JSON.parse(response.body)

  redirect '/collaborate'
end

get '/collaborate' do
  haml :collaborate
end

post '/collaborate' do
  @loanofficer_email = params[:email]

  Pony.mail(
    :to => 'opal.kale@gmail.com',
    :body => 'Hello! We have created a shared folder box.com! You can access the folder here:',
    :subject => "Your client wants to share an HSBC Loan Application with you!"
    )
  
  redirect '/completed'
end 

get '/completed' do
  haml :completed
end