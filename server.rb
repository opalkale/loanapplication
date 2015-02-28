require 'sinatra'
require 'erb'
require 'httparty'
require 'pony'
require 'json'
require 'byebug'
require 'skeleton'

BOX_BASE_URL = "https://api.box.com/2.0/folders/"

# For flash messages
# enable :sessions

get '/' do
  erb :index
end

post '/' do

  # Check to see that the fields are not empty
  if (params[:first_name].empty? || params[:last_name].empty?)
    # flash[:notice] = "Name cannot be blank"
    redirect '/'
  end

  if (params[:client_email].empty? || params[:loan_officer_email].empty?)
    # flash[:notice] = "Email cannot be blank"
    redirect '/'
  end

  # Add form parameters to database.
  client_email = params[:client_email]
  client_name = params[:first_name] + " " + params[:last_name]
  loan_officer_email = params[:loan_officer_email]
  @client_full_name = client_name
  
  folder_name = "#{client_name} - #{client_email} - loan application"

  # Create a new folder via a POST request and save returning JSON object.
  folder_creation_response = HTTParty.post(BOX_BASE_URL, 
    {
      :headers => { 'Authorization' => 'Bearer k8jKcmbRmr6s5dDL55IcLAp1UAYeUpuG' },
      :body => { "name" => folder_name, "parent" => {"id" => "0"} }.to_json
    })

  if !folder_creation_response.success?
    redirect "/?error=true"
  end

  # Create a hash from the response object.
  response_hash = JSON.parse(folder_creation_response.body)  

  # Access folder's id in response hash.
  id = response_hash["id"]

  # Concatenate box base uri wih unique folder id.
  folder_url = BOX_BASE_URL + id
  
  # Create a shared link via a PUT request and save returning JSON object.
  shared_link_creation_response = HTTParty.put(folder_url, 
    {
      :headers => { 'Authorization' => 'Bearer k8jKcmbRmr6s5dDL55IcLAp1UAYeUpuG' },
      :body => { "shared_link" => {"access" => "open"} }.to_json
    })

  # Create a hash from the response object.
  response_hash_2 = JSON.parse(shared_link_creation_response.body)
  
  # Access the shared link url in response hash.

  @shared_link_url = response_hash_2["shared_link"]["url"]


  # E-mails loan officer with shared link url.
  Pony.mail(
    :to => 'opal.kale@gmail.com',
    :body => erb(:email),
    :subject => "Your client " + @client_full_name + " wants to share an HSBC Loan Application with you!"
  )

  # Render the completed page
  erb :completed 

end 
