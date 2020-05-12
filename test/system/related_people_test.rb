require "application_system_test_case"

class RelatedPeopleTest < ApplicationSystemTestCase
  setup do
    @related_person = related_people(:one)
  end

  test "visiting the index" do
    visit related_people_url
    assert_selector "h1", text: "Related People"
  end

  test "creating a Related person" do
    visit related_people_url
    click_on "New Related Person"

    click_on "Create Related person"

    assert_text "Related person was successfully created"
    click_on "Back"
  end

  test "updating a Related person" do
    visit related_people_url
    click_on "Edit", match: :first

    click_on "Update Related person"

    assert_text "Related person was successfully updated"
    click_on "Back"
  end

  test "destroying a Related person" do
    visit related_people_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Related person was successfully destroyed"
  end
end
