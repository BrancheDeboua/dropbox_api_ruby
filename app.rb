require 'rubygems'
require 'excon'
require 'json'

folder = "henry"

r = Excon.post('https://api.dropboxapi.com/2/files/create_folder_v2',
    :body => "{ \"path\": \"/#{folder}\", \"autorename\": false }",
    :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['DBKEY']}" }
)

# This is how you parse the json response from the api
result  = JSON.parse(r.data[:body])
if result['metadata']
    p "poulet"
else
    p "felip"
end