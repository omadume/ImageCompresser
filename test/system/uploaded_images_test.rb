require "application_system_test_case"

class UploadedImagesTest < ApplicationSystemTestCase
  setup do
    @uploaded_image = uploaded_images(:one)
  end

  test "visiting the index" do
    visit uploaded_images_url
    assert_selector "h1", text: "Uploaded Images"
  end

  test "creating a Uploaded image" do
    visit uploaded_images_url
    click_on "New Uploaded Image"

    fill_in "Image", with: @uploaded_image.image
    click_on "Create Uploaded image"

    assert_text "Uploaded image was successfully created"
    click_on "Back"
  end

  test "updating a Uploaded image" do
    visit uploaded_images_url
    click_on "Edit", match: :first

    fill_in "Image", with: @uploaded_image.image
    click_on "Update Uploaded image"

    assert_text "Uploaded image was successfully updated"
    click_on "Back"
  end

  test "destroying a Uploaded image" do
    visit uploaded_images_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Uploaded image was successfully destroyed"
  end
end
