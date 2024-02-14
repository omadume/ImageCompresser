require 'base64'
require 'net/http'

class UploadedImagesController < ApplicationController
  before_action :set_uploaded_image, only: %i[ show destroy ] # An ID is required to perform these methods

  # API configurations
  API_KEY = 'A795D22D-A334-4A72-BE82-3A7F1DB9973BA3F5E7A2-CADA-4235-B875-414034D95D32'  # visit https://astica.ai
  API_TIMEOUT = 25 # in seconds. "gpt" or "gpt_detailed" require increased timeouts
  API_ENDPOINT = 'https://vision.astica.ai/describe'
  API_MODELVER = '2.1_full' # '1.0_full', '2.0_full', or '2.1_full'

  # Function to return the base64 string representation of an image
  def get_image_base64_encoding
    image_path = uploaded_image_params[:image] 
    image_file = File.open(image_path, 'rb')
    image_data = image_file.read()
    base64_encoded = Base64.encode64(image_data)
    return base64_encoded
  end

  def asticaAPI(endpoint, payload, timeout) # Currently giving response 302
    url = URI.parse(endpoint)
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url.to_s, {'Content-Type' => 'application/json'})
    request.body = payload.to_json
    response = http.request(request)
    puts response.body if response.present?
    
    # if response.status_code == 200:
    #     return response.json()
    # else:
    #     return {'status': 'error', 'error': 'Failed to connect to the API.'}
  end

  # GET /uploaded_images/1 or /uploaded_images/1.json
  def show
  end

  # GET /uploaded_images/new
  def new
    @uploaded_image = UploadedImage.new
  end

  # POST /uploaded_images or /uploaded_images.json
  def create
    @uploaded_image = UploadedImage.new(uploaded_image_params)
    asticaAPI_input = get_image_base64_encoding
    asticaAPI_payload = {
      'tkn': API_KEY,
      'modelVersion': API_MODELVER,
      'visionParams': 'describe',
      'input': asticaAPI_input,
    }
    asticaAPI_result = asticaAPI(API_ENDPOINT, asticaAPI_payload, API_TIMEOUT)
    #TODO: save description from result and put on show page for image
    
    respond_to do |format|
      if @uploaded_image.save
        @uploaded_image.image.recreate_versions! # explicitly trigger the image processing pipeline in CarrierWave after making changes to the model
        format.html { redirect_to uploaded_image_url(@uploaded_image), notice: "Uploaded image was successfully uploaded & compressed." }
        format.json { render :show, status: :created, location: @uploaded_image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @uploaded_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploaded_images/1 or /uploaded_images/1.json - TODO: use for rake task bulk delete later on
  def destroy
    @uploaded_image.destroy

    respond_to do |format|
      format.html { redirect_to uploaded_images_url, notice: "Uploaded image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_uploaded_image
      @uploaded_image = UploadedImage.find(params[:id])
    end

    # Only allow a list of trusted parameters
    def uploaded_image_params
      params.require(:uploaded_image).permit(:image, :compression)
    end
end
