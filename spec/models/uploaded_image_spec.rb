require 'rails_helper'

RSpec.describe UploadedImage, :type => :model do

  let(:imageFile) {File.open("#{fixture_path}/test_files/test.jpeg")}

  it "is valid with valid attributes" do
    uploadedImage = UploadedImage.new(image: imageFile, compression: 50)
    expect(uploadedImage).to be_valid
  end

  it "is not valid without an image" do
    uploadedImage = UploadedImage.new(compression: 50)
    expect(uploadedImage).to_not be_valid
  end

  it "is not valid without a compression value" do
    uploadedImage = UploadedImage.new(image: imageFile)
  end
end