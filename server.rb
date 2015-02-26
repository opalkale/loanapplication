require 'sinatra'
require 'haml'
require 'httparty'
require 'pony'
require 'json'

base_url= "https://api.box.com/2.0/folders/"

get '/' do
  haml :index
end

post '/' do
  # Save form params.
  @client_email = params[:email]
  @first_name = params[:first_name]
  @last_name = params[:last_name]

  # Create a new folder via a POST request and save returning JSON object.
  response = HTTParty.post(base_url, 
    {
      :headers => { 'Authorization' => 'Bearer W73oCHjgpCvsZ7tRXxzezgf6byzHXAXR' },
      :body => { "name" => @client_email, "parent" => {"id" => "0"} }.to_json
    })

  # Create a hash from the response object.
  response_hash = JSON.parse(response.body)  

  # Access folder's id in response hash.
  @id = response_hash["id"]

  # Concatenate box base uri wih unique folder id.
  folder_url = base_url.concat(@id)

  # Create a shared link via a PUT request and save returning JSON object.
  response_2 = HTTParty.put(folder_url, 
    {
      :headers => { 'Authorization' => 'Bearer W73oCHjgpCvsZ7tRXxzezgf6byzHXAXR' },
      :body => { "shared_link" => {"access" => "open"} }.to_json
    })

  # Create a hash from the response object.
  response_hash_2 = JSON.parse(response_2.body)

  # Access the shared link url in response hash.
  @shared_link_url = response_hash_2["shared_link"]["url"]
  
  # Prints shared link url
  puts @shared_link_url

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