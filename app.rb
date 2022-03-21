require 'excon'
require 'json'




def send_file
    file = File.open('chicken.jpeg')
    r = Excon.post("https://content.dropboxapi.com/2/files/upload_session/start",
        :headers => { 'Content-Type' => 'application/octet-stream', 'Authorization' => "Bearer #{ENV['DBKEY']}", 'Dropbox-API-Arg' => '{"close": true}' },
        :body => file
    )

    p r.body
    result = Excon.post("https://content.dropboxapi.com/2/files/upload_session/finish",
        :headers => { 'Content-Type' => 'application/octet-stream', 'Authorization' => "Bearer #{ENV['DBKEY']}", 'Dropbox-API-Arg' => "{\"cursor\": \"{ \"session_id\": \"#{r.body['session_id']}\", \"offset\": 0 }\"}" },
        :body => file
    )
    p result.body
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
    send_file
else
    if result['error_summary'] == 'path/conflict/folder/' || result['error_summary'] == 'path/conflict/folder/...' || result['error_summary'] == 'path/conflict/folder/.' || result['error_summary'] == 'path/conflict/folder/..'
        # Here the folder already exists and we can add the file in it already
        send_file
    else
        # Error wtf Jim
        p result['error_summary']
    end
end

