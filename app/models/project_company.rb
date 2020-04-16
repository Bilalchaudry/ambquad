class ProjectCompany < ApplicationRecord
  audited
  belongs_to :client_company
  has_many :employees
  has_many :plants
  has_many :project_plants

  has_many :project_and_project_companies
  has_many :projects, :through => :project_and_project_companies, dependent: :destroy

  def self.import(file, user, project)
    if user.client_company == nil
      client_company = 1
    else
      client_company = user.client_company.id
    end
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        employee = project.project_companies.create(company_name: row[0], company_summary: row[1], project_role: row[2], address: row[3], country_name: row[4], phone: row[5],
                                         primary_poc_first_name: row[6], primary_poc_last_name: row[7], poc_email: row[8], poc_country: row[9], poc_phone: row[10],
                                         client_company_id: project.client_company.id, project_id: project.id)
      end
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            employee = project.project_companies.create(project_id: project.id, company_name: row['company_name'], company_summary: row['company_summary'],
                                             project_role: row['project_role'], address: row['address'], country_name: row['country_name'], phone: row['phone'],
                                             primary_poc_first_name: row['primary_poc_first_name'], primary_poc_last_name: row['primary_poc_last_name'],
                                             poc_email: row['poc_email'], poc_country: row['poc_country'], poc_phone: row['poc_phone'])
            employee.save!
          end
        end
      else
        return false
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then
      Roo::CSV.new(file.path, nil, :ignore)
    when ".xlsx" then
      Roo::Excelx.new(file.path)
    when ".xls" then
      Roo::Excel.new(file.path)
    else
      return false
    end
  end

end