require "application_system_test_case"

class ProjectCompaniesTest < ApplicationSystemTestCase
  setup do
    @project_company = project_companies(:one)
  end

  test "visiting the index" do
    visit project_companies_url
    assert_selector "h1", text: "Project Companies"
  end

  test "creating a Project company" do
    visit project_companies_url
    click_on "New Project Company"

    fill_in "Address", with: @project_company.address
    fill_in "Client company", with: @project_company.client_company_id
    fill_in "Company summary", with: @project_company.company_summary
    fill_in "Phone", with: @project_company.phone
    fill_in "Poc email", with: @project_company.poc_email
    fill_in "Poc phone", with: @project_company.poc_phone
    fill_in "Primary poc first name", with: @project_company.primary_poc_first_name
    fill_in "Primary poc last name", with: @project_company.primary_poc_last_name
    fill_in "Project", with: @project_company.project_id
    fill_in "Project role", with: @project_company.project_role
    click_on "Create Project company"

    assert_text "Project company was successfully created"
    click_on "Back"
  end

  test "updating a Project company" do
    visit project_companies_url
    click_on "Edit", match: :first

    fill_in "Address", with: @project_company.address
    fill_in "Client company", with: @project_company.client_company_id
    fill_in "Company summary", with: @project_company.company_summary
    fill_in "Phone", with: @project_company.phone
    fill_in "Poc email", with: @project_company.poc_email
    fill_in "Poc phone", with: @project_company.poc_phone
    fill_in "Primary poc first name", with: @project_company.primary_poc_first_name
    fill_in "Primary poc last name", with: @project_company.primary_poc_last_name
    fill_in "Project", with: @project_company.project_id
    fill_in "Project role", with: @project_company.project_role
    click_on "Update Project company"

    assert_text "Project company was successfully updated"
    click_on "Back"
  end

  test "destroying a Project company" do
    visit project_companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project company was successfully destroyed"
  end
end
