require "application_system_test_case"

class PractitionerRolesTest < ApplicationSystemTestCase
  setup do
    @practitioner_role = practitioner_roles(:one)
  end

  test "visiting the index" do
    visit practitioner_roles_url
    assert_selector "h1", text: "Practitioner Roles"
  end

  test "creating a Practitioner role" do
    visit practitioner_roles_url
    click_on "New Practitioner Role"

    click_on "Create Practitioner role"

    assert_text "Practitioner role was successfully created"
    click_on "Back"
  end

  test "updating a Practitioner role" do
    visit practitioner_roles_url
    click_on "Edit", match: :first

    click_on "Update Practitioner role"

    assert_text "Practitioner role was successfully updated"
    click_on "Back"
  end

  test "destroying a Practitioner role" do
    visit practitioner_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Practitioner role was successfully destroyed"
  end
end
