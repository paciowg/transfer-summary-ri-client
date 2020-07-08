require "application_system_test_case"

class EltssQuestionnairesTest < ApplicationSystemTestCase
  setup do
    @eltss_questionnaire = eltss_questionnaires(:one)
  end

  test "visiting the index" do
    visit eltss_questionnaires_url
    assert_selector "h1", text: "Eltss Questionnaires"
  end

  test "creating a Eltss questionnaire" do
    visit eltss_questionnaires_url
    click_on "New Eltss Questionnaire"

    click_on "Create Eltss questionnaire"

    assert_text "Eltss questionnaire was successfully created"
    click_on "Back"
  end

  test "updating a Eltss questionnaire" do
    visit eltss_questionnaires_url
    click_on "Edit", match: :first

    click_on "Update Eltss questionnaire"

    assert_text "Eltss questionnaire was successfully updated"
    click_on "Back"
  end

  test "destroying a Eltss questionnaire" do
    visit eltss_questionnaires_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Eltss questionnaire was successfully destroyed"
  end
end
