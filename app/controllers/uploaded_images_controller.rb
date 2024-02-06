class UploadedImagesController < ApplicationController
  before_action :set_uploaded_image, only: %i[ show destroy ] # An ID is required to perform these methods

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
