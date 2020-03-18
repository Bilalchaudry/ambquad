require "application_system_test_case"

class OtherManagersTest < ApplicationSystemTestCase
  setup do
    @other_manager = other_managers(:one)
  end

  test "visiting the index" do
    visit other_managers_url
    assert_selector "h1", text: "Other Managers"
  end

  test "creating a Other manager" do
    visit other_managers_url
    click_on "New Other Manager"

    fill_in "Employee", with: @other_manager.employee_id
    fill_in "Type", with: @other_manager.type
    click_on "Create Other manager"

    assert_text "Other manager was successfully created"
    click_on "Back"
  end

  test "updating a Other manager" do
    visit other_managers_url
    click_on "Edit", match: :first

    fill_in "Employee", with: @other_manager.employee_id
    fill_in "Type", with: @other_manager.type
    click_on "Update Other manager"

    assert_text "Other manager was successfully updated"
    click_on "Back"
  end

  test "destroying a Other manager" do
    visit other_managers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Other manager was successfully destroyed"
  end
end
