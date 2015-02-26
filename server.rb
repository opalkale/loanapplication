require 'sinatra'
require 'haml'
require 'httparty'
require 'pony'
require 'json'

get '/' do
  haml :index
end

post '/' do
  # Save form params.
  @client_email = params[:email]
  @first_name = params[:first_name]
  @last_name = params[:last_name]

  # Create a new folder via a POST request and save returning JSON object.
  response = HTTParty.post("https://api.box.com/2.0/folders/", 
    {
      :headers => { 'Authorization' => 'Bearer jSLGLWMam9y4w89H8v4NfQmusPeMnLtk' },
      :body => { "name" => @client_email, "parent" => {"id" => "0"} }.to_json
    })

  # Create a hash from the response object.
  response_hash = JSON.parse(response.body)  

  # Access folder's id.
  puts response_hash["id"]
  
  # Create a shared link
  #response = HTTParty.put("https://api.box.com/2.0/folders/", 
  #  {
  #    :headers => { 'Authorization' => 'Bearer jSLGLWMam9y4w89H8v4NfQmusPeMnLtk' },
  #    :body => { "shared_link" => {"access" => "open"} }.to_json
  #  })

 

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