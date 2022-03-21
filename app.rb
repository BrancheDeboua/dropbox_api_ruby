require 'excon'
require 'json'
require 'dropbox_api'

def send_file(fichier)
    file = File.open('chicken.jpeg')
    client = DropboxApi::Client.new
    client.upload_by_chunks "/#{fichier}/patate", file
end

folder = "henry"


r = Excon.post('https://api.dropboxapi.com/2/files/create_folder_v2',
    :body => "{ \"path\": \"/#{folder}\", \"autorename\": false }",
    :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['DBKEY']}" }
)

#This is how you parse the json response from the api
result  = JSON.parse(r.body)
if result['metadata']
    # Here the folder has been created by the request before, need to create add the file inside the folder
    send_file folder
else
    if result['error_summary'] == 'path/conflict/folder/' || result['error_summary'] == 'path/conflict/folder/...' || result['error_summary'] == 'path/conflict/folder/.' || result['error_summary'] == 'path/conflict/folder/..'
        # Here the folder already exists and we can add the file in it already
        send_file folder
    else
        # Error wtf Jim
        p result['error_summary']
    end
end

