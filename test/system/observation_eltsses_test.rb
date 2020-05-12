require "application_system_test_case"

class ObservationEltssesTest < ApplicationSystemTestCase
  setup do
    @observation_eltss = observation_eltsses(:one)
  end

  test "visiting the index" do
    visit observation_eltsses_url
    assert_selector "h1", text: "Observation Eltsses"
  end

  test "creating a Observation eltss" do
    visit observation_eltsses_url
    click_on "New Observation Eltss"

    click_on "Create Observation eltss"

    assert_text "Observation eltss was successfully created"
    click_on "Back"
  end

  test "updating a Observation eltss" do
    visit observation_eltsses_url
    click_on "Edit", match: :first

    click_on "Update Observation eltss"

    assert_text "Observation eltss was successfully updated"
    click_on "Back"
  end

  test "destroying a Observation eltss" do
    visit observation_eltsses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Observation eltss was successfully destroyed"
  end
end
