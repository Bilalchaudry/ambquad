require 'test_helper'

class ProjectCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_company = project_companies(:one)
  end

  test "should get index" do
    get project_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_project_company_url
    assert_response :success
  end

  test "should create project_company" do
    assert_difference('ProjectCompany.count') do
      post project_companies_url, params: { project_company: { address: @project_company.address, client_company_id: @project_company.client_company_id, company_summary: @project_company.company_summary, phone: @project_company.phone, poc_email: @project_company.poc_email, poc_phone: @project_company.poc_phone, primary_poc_first_name: @project_company.primary_poc_first_name, primary_poc_last_name: @project_company.primary_poc_last_name, project_id: @project_company.project_id, project_role: @project_company.project_role } }
    end

    assert_redirected_to project_company_url(ProjectCompany.last)
  end

  test "should show project_company" do
    get project_company_url(@project_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_company_url(@project_company)
    assert_response :success
  end

  test "should update project_company" do
    patch project_company_url(@project_company), params: { project_company: { address: @project_company.address, client_company_id: @project_company.client_company_id, company_summary: @project_company.company_summary, phone: @project_company.phone, poc_email: @project_company.poc_email, poc_phone: @project_company.poc_phone, primary_poc_first_name: @project_company.primary_poc_first_name, primary_poc_last_name: @project_company.primary_poc_last_name, project_id: @project_company.project_id, project_role: @project_company.project_role } }
    assert_redirected_to project_company_url(@project_company)
  end

  test "should destroy project_company" do
    assert_difference('ProjectCompany.count', -1) do
      delete project_company_url(@project_company)
    end

    assert_redirected_to project_companies_url
  end
end
