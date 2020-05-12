require "application_system_test_case"

class ServiceRequestsTest < ApplicationSystemTestCase
  setup do
    @service_request = service_requests(:one)
  end

  test "visiting the index" do
    visit service_requests_url
    assert_selector "h1", text: "Service Requests"
  end

  test "creating a Service request" do
    visit service_requests_url
    click_on "New Service Request"

    click_on "Create Service request"

    assert_text "Service request was successfully created"
    click_on "Back"
  end

  test "updating a Service request" do
    visit service_requests_url
    click_on "Edit", match: :first

    click_on "Update Service request"

    assert_text "Service request was successfully updated"
    click_on "Back"
  end

  test "destroying a Service request" do
    visit service_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Service request was successfully destroyed"
  end
end
