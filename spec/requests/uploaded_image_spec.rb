require 'rails_helper'

RSpec.describe "UploadedImages", type: :request do

  let(:imageFile_jpeg) {File.open("#{fixture_path}/test_files/test.jpeg")}
  let(:imageFile_png) {File.open("#{fixture_path}/test_files/test.png")}

  describe "GET /uploaded_images/new" do
     it "returns HTTP success" do
        get new_uploaded_image_path
        expect(response.status).to eq(200)
     end
  end

  describe "POST /uploaded_images" do
    it "returns HTTP redirect to 'show' path for newly created image when sent valid parameters" do
      post uploaded_images_path, params: {
        uploaded_image: {
          image: fixture_file_upload(imageFile_jpeg, 'image/jpeg'),
          compression: 50
        }
      }
      expect(response).to redirect_to(uploaded_image_path(UploadedImage.last))
      expect(response.status).to eq(302)
    end

    it "returns HTTP unprocessable when sent invalid parameters - no compression value" do
      post uploaded_images_path, params: {
        uploaded_image: {
          image: fixture_file_upload(imageFile_jpeg)
        }
      }
      expect(response.status).to eq(422)
    end

    it "returns HTTP unprocessable when sent invalid parameters - invalid image format" do
      post uploaded_images_path, params: {
        uploaded_image: {
          image: fixture_file_upload(imageFile_png, 'image/png'),
          compression: 50
        }
      }
      expect(response.status).to eq(422)
    end
  end
end