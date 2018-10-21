require "application_system_test_case"

class StreamPackagesTest < ApplicationSystemTestCase
  setup do
    @stream_package = stream_packages(:one)
  end

  test "visiting the index" do
    visit stream_packages_url
    assert_selector "h1", text: "Stream Packages"
  end

  test "creating a Stream package" do
    visit stream_packages_url
    click_on "New Stream Package"

    fill_in "Cost", with: @stream_package.cost
    fill_in "Name", with: @stream_package.name
    click_on "Create Stream package"

    assert_text "Stream package was successfully created"
    click_on "Back"
  end

  test "updating a Stream package" do
    visit stream_packages_url
    click_on "Edit", match: :first

    fill_in "Cost", with: @stream_package.cost
    fill_in "Name", with: @stream_package.name
    click_on "Update Stream package"

    assert_text "Stream package was successfully updated"
    click_on "Back"
  end

  test "destroying a Stream package" do
    visit stream_packages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Stream package was successfully destroyed"
  end
end
