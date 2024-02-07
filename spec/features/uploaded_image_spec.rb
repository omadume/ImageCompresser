require 'rails_helper'

RSpec.feature "UploadedImages" do
  let(:imageFile) {"#{fixture_path}/test_files/test.jpeg"}

  context "when a user visits the root page" do
    it "goes to the view for the 'new' action" do
      visit '/'
      expect(page).to have_content "Upload an image to compress"
    end
  end

  context "when a user uploads an image to compress" do
    it "shows an error message if the image submission was invalid - compression field blank" do
      visit '/'
      expect(page).to have_content "Compression level (percentage)" # Do not fill in compression field value
      page.attach_file(imageFile)
      click_button "Upload image"
      expect(page).to have_content "1 error prohibited this uploaded_image from being saved"
      expect(page).to have_content "Compression can't be blank"
    end

    it "shows an error message if the image submission was invalid - image field blank" do
      visit '/'
      expect(page).to have_content "Compression level (percentage)"
      fill_in "Compression level (percentage)", with: 30
      click_button "Upload image"
      expect(page).to have_content "1 error prohibited this uploaded_image from being saved"
      expect(page).to have_content "Image can't be blank"
    end
  end
end