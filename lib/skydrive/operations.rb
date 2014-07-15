module Skydrive
  # The basic operations
  module Operations
    require 'uri'
    require 'net/http'

    # Your home folder
    # @return [Skydrive::Folder]
    def my_skydrive
      response = get("/me/skydrive")
    end

    # Get the home folder of a particular user
    # @param [String] user_id ID of the user
    # @return [Skydrive::Folder]
    def user_skydrive user_id
      response = get("/#{user_id}/skydrive")
    end

    # Your camera_roll folder
    # @return [Skydrive::Folder]
    def my_camera_roll
      response = get("/me/skydrive/camera_roll")
    end

    # Get the camera_roll folder of a particular user
    # @param [String] user_id ID of the user
    # @return [Skydrive::Folder]
    def user_camera_roll user_id
      response = get("/#{user_id}/camera_roll")
    end

    # Your documents
    # @return [Skydrive::Folder]
    def my_documents
      response = get("/me/skydrive/my_documents")
    end

    # User's documents
    # @param [String] user_id ID of the user
    # @return [Skydrive::Folder]
    def user_documents user_id
      response = get("/#{user_id}/skydrive/my_documents")
    end

    # Your default album
    # @return [Skydrive::Album]
    def my_photos
      response = get("/me/skydrive/my_photos")
    end

    # User's photos
    # @param [String] user_id ID of the user
    # @return [Skydrive::Folder]
    def user_photos user_id
      response = get("/#{user_id}/skydrive/my_photos")
    end

    # Your public documents
    # @return [Skydrive::Folder]
    def my_public_documents
      response = get("/me/skydrive/public_documents")
    end

    # User's public documents
    # @param [String] user_id ID of the user
    # @return [Skydrive::Folder]
    def user_public_documents user_id
      response = get("/#{user_id}/skydrive/public_documents")
    end

    # Your shared items
    # @return [Skydrive::Collection]
    def my_shared_stuff
      response = get("/me/skydrive/shared")
    end

    # User's shared items
    # @return [Skydrive::Collection]
    def user_shared_stuff
      response = get("/#{id}/skydrive/shared")
    end

    # Your recent documents
    # @param [String] user_id ID of the user
    # @return [Skydrive::Collection]
    def my_recent_documents
      response = get("/me/skydrive/recent_docs")
    end

    # User's recent documents
    # @param [String] user_id ID of the user
    # @return [Skydrive::Collection]
    def user_recent_documents user_id
      response = get("/#{user_id}/skydrive/recent_docs")
    end

    # Your total and remaining storage quota
    # @return [Hash] contains keys quota and available
    def my_storage_quota
      response = get("/me/skydrive/quota")
    end

    # User's total and remaining storage quota
    # @return [Hash] contains keys quota and available
    def user_storage_quota
      response = get("/me/skydrive/quota")
    end

    # Delete an object with given id
    # @param [String] object_id the id of the object to be deleted
    def delete_skydrive_object object_id
      response = delete("/#{object_id}")
    end

    # Update a skydrive object
    # @param [String] object_id the id of the object to be updated
    # @param [Hash] options The properties to be updated
    # @option options [String] :name The friendly name of the object
    # @option options [String] :description The description text about the object
    def update_skydrive_object object_id, options={}
      response = put("/#{object_id}", options)
    end

    # Get an object by its id
    # @param [String] id The id of the object you want
    def get_skydrive_object_by_id id
      response = get("/#{id}")
    end

    alias :update_folder :update_skydrive_object
    alias :update_album :update_skydrive_object
    alias :update_file :update_skydrive_object
    alias :update_video :update_skydrive_object
    alias :update_audio :update_skydrive_object
    alias :update_photo :update_skydrive_object

    alias :delete_folder :delete_skydrive_object
    alias :delete_album :delete_skydrive_object
    alias :delete_file :delete_skydrive_object
    alias :delete_video :delete_skydrive_object
    alias :delete_audio :delete_skydrive_object
    alias :delete_photo :delete_skydrive_object
    # Create a new folder
    # @param [String] path the path where the new folder should be created
    # @param [Hash] options the details of the new folder
    # @option options [String] :name required, the name of the new folder
    # @option options [String] :description the description about the folder
    # @return [Skydrive::Folder] the new folder
    def create_folder path, options={}
      response = post("/#{path}", options)
    end

    # Create a new album. Albums can only be created in the path '/me/albums', so no need to pass the path as a parameter
    # @param [Hash] options the details of the new album
    # @option options [String] :name required, the name of the new album
    # @option options [String] :description the description about the album
    # @return [Skydrive::Album] the new album
    def create_album options={}
      response = post("/me/albums", options)
    end

    # Get comments associated with an object
    # @param [String] object_id The ID of the object
    # @return [Skydrive::Collection]
    def object_comments object_id
      response = get("/#{object_id}/comments")
    end

    # Delete a comment
    # @param [String] comment_id TD od the comment
    def delete_comment comment_id
      response = delete("/#{comment_id}")
    end

    # Comment about an object
    # @param [String] object_id ID of the object
    # @param [Hash] options
    # @option options [String] :message The comment message
    def create_comment object_id, options={}
      response = post("/#{object_id}/comments", options)
    end

    # @param [String] upload_path url for the folder to which the file will be uploaded
    # (eg. https://apis.live.net/v5.0/me/skydrive or replace /me/skydrive for the folder id)
    # @param [String] doc_name Name of the file
    # @param [String] token Client access token
    # @param [Tempfile] Tempfile created to upload the file
    def upload_file(upload_path, doc_name, token, tempfile)
      site = upload_path + "/files?access_token="+ token.to_s
      boundary = 'A300x'
      uri = URI.parse(site)
      post_body = []
      post_body << "--" + boundary + "\r\n"
      post_body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{doc_name}\"\r\n"
      post_body << "Content-Type: application/octet-stream,\"\r\n"
      post_body << "\r\n"
      post_body << File.read(tempfile)
      post_body << "\r\n"
      post_body << "--"+ boundary +"--\r\n"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "multipart/form-data; boundary=" + boundary
      request.body = post_body.join
      response = http.request(request)
      response
    end

  end
end