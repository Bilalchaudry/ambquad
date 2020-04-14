class Employee < ApplicationRecord
  validates :phone, :email, uniqueness: true
  # belongs_to :project_company, optional: true

  belongs_to :client_company
  belongs_to :project_company
  belongs_to :project
  has_many :project_employees
  has_many :foremen
  has_many :other_managers
  has_many :budget_holders
  has_many :employee_types

  enum gender: {
      Male: 0,
      Female: 1
  }
  enum status: {
      Active: 0,
      Onhold: 1,
      Closed: 2
  }

  def self.import(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        begin
        if row[6] == 'm' || row[6] == 'M' || row[6] == 'Male' || row[6] == 'male'
          row[6] = "Male"
        elsif row[6] == 'f' || row[6] == 'F' || row[6] == 'Female' || row[6] == 'female'
          row[6] = "Female"
        else
          row[6] = "Male"
        end

        if row[8] == 'Active' || row[8] == 'a' || row[8] == 'A' || row[8] == 'active'
          row[8] = "Active"
        elsif row[8] == 'Closed' || row[8] == 'closed' || row[8] == 'c' || row[8] == 'c' || row[8] == 'close' || row[8] == 'Close'
          row[8] = "Closed"
        elsif row[8] == 'Onhold' || row[8] == 'onhold' || row[8] == 'o' || row[8] == 'O' || row[8] == 'OnHold' || row[8] == 'onHold'
          row[8] = "Onhold"
        else
          row[8] = "Active"
        end
        id_project_company = ProjectCompany.where(company_name: row[9]).first
        if id_project_company.nil?
          row[9] = ''
        else
          row[9] = id_project_company.id
        end

        employee = project.employees.create!(first_name: row[0], last_name: row[1], employee_id: row[2], country_name: row[3], phone: row[4], email: row[5],
                                            gender: row[6], home_company_role: row[7], status: row[8], project_company_id: row[9], client_company_id: user.client_company_id)
        rescue => e
          return e.message
        end
      end
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            employee = project.employees.create(first_name: row['first_name'], last_name: row['last_name'], employee_id: row['employee_id'], country_name: row['country_name'],
                                                phone: row['phone'], email: row['email'], gender: row['gender'], home_company_role: row['home_company_role'], status: row['status'],
                                                project_company_id: row['project_company_name'], client_company_id: user.client_company_id)
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
