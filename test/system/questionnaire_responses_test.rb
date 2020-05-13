require "application_system_test_case"

class QuestionnaireResponsesTest < ApplicationSystemTestCase
  setup do
    @questionnaire_response = questionnaire_responses(:one)
  end

  test "visiting the index" do
    visit questionnaire_responses_url
    assert_selector "h1", text: "Questionnaire Responses"
  end

  test "creating a Questionnaire response" do
    visit questionnaire_responses_url
    click_on "New Questionnaire Response"

    click_on "Create Questionnaire response"

    assert_text "Questionnaire response was successfully created"
    click_on "Back"
  end

  test "updating a Questionnaire response" do
    visit questionnaire_responses_url
    click_on "Edit", match: :first

    click_on "Update Questionnaire response"

    assert_text "Questionnaire response was successfully updated"
    click_on "Back"
  end

  test "destroying a Questionnaire response" do
    visit questionnaire_responses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Questionnaire response was successfully destroyed"
  end
end
