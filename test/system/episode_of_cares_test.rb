require "application_system_test_case"

class EpisodeOfCaresTest < ApplicationSystemTestCase
  setup do
    @episode_of_care = episode_of_cares(:one)
  end

  test "visiting the index" do
    visit episode_of_cares_url
    assert_selector "h1", text: "Episode Of Cares"
  end

  test "creating a Episode of care" do
    visit episode_of_cares_url
    click_on "New Episode Of Care"

    click_on "Create Episode of care"

    assert_text "Episode of care was successfully created"
    click_on "Back"
  end

  test "updating a Episode of care" do
    visit episode_of_cares_url
    click_on "Edit", match: :first

    click_on "Update Episode of care"

    assert_text "Episode of care was successfully updated"
    click_on "Back"
  end

  test "destroying a Episode of care" do
    visit episode_of_cares_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Episode of care was successfully destroyed"
  end
end
