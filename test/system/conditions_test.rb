require "application_system_test_case"

class ConditionsTest < ApplicationSystemTestCase
  setup do
    @condition = conditions(:one)
  end

  test "visiting the index" do
    visit conditions_url
    assert_selector "h1", text: "Conditions"
  end

  test "creating a Condition" do
    visit conditions_url
    click_on "New Condition"

    click_on "Create Condition"

    assert_text "Condition was successfully created"
    click_on "Back"
  end

  test "updating a Condition" do
    visit conditions_url
    click_on "Edit", match: :first

    click_on "Update Condition"

    assert_text "Condition was successfully updated"
    click_on "Back"
  end

  test "destroying a Condition" do
    visit conditions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Condition was successfully destroyed"
  end
end
