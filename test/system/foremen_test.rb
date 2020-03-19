require "application_system_test_case"

class ForemenTest < ApplicationSystemTestCase
  setup do
    @foreman = foremen(:one)
  end

  test "visiting the index" do
    visit foremen_url
    assert_selector "h1", text: "Foremen"
  end

  test "creating a Foreman" do
    visit foremen_url
    click_on "New Foreman"

    fill_in "Employee", with: @foreman.employee_id
    click_on "Create Foreman"

    assert_text "Foreman was successfully created"
    click_on "Back"
  end

  test "updating a Foreman" do
    visit foremen_url
    click_on "Edit", match: :first

    fill_in "Employee", with: @foreman.employee_id
    click_on "Update Foreman"

    assert_text "Foreman was successfully updated"
    click_on "Back"
  end

  test "destroying a Foreman" do
    visit foremen_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Foreman was successfully destroyed"
  end
end
