require 'sinatra'
require 'haml'
require 'httparty'
require 'pony'

get '/' do
  haml :index
end

post '/' do
  @client_email = params[:email]

  HTTParty.post("https://api.box.com/2.0/folders/", 
    {
      :headers => { 'Authorization' => 'Bearer YGkMr3It8KnoPTbOxuS8lZvDUtR3rYRD' },
      :body => { "name" => @client_email, "parent" => {"id" => "0"} }.to_json
    })

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
  
  redirect '/create'
end 

get '/create' do
  haml :create
end