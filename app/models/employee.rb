class Employee < ApplicationRecord
  validates :phone, :email, uniqueness: true
  # belongs_to :project_company, optional: true

  belongs_to :client_company
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

  def self.import(file, user)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        if row[5] == 'm' || row[5] == 'M' || row[5] == 'Male' || row[5] == 'male'
          row[5] = "Male"
        elsif row[5] == 'f' || row[5] == 'F' || row[5] == 'Female' || row[5] == 'female'
          row[5] = "Female"
        else
          row[5] = "Male"
        end

        if row[9] == 'Active' || row[9] == 'a' || row[9] == 'A' || row[9] == 'active'
          row[9] = "Active"
        elsif row[9] == 'Closed' || row[9] == 'closed' || row[9] == 'c' || row[9] == 'c' || row[9] == 'close' || row[9] == 'Close'
          row[9] = "Closed"
        elsif row[9] == 'Onhold' || row[9] == 'onhold' || row[9] == 'o' || row[9] == 'O' || row[9] == 'OnHold' || row[9] == 'onHold'
          row[9] = "Onhold"
        else
          row[9] = "Active"
        end
        employee = Employee.create(first_name: row[0], last_name: row[1], employee_id: row[2], phone: row[3], email: row[4], gender: row[5], home_company_role: row[6],
                                   contract_start_date: row[7], contract_end_date: row[8], status: row[9], project_id: row[10], employee_type_id: row[11],
                                   foreman_id: row[12], other_manager_id: row[13], project_company_id: row[14], client_company_id: user.client_company_id)
      end
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            employee = Employee.create(first_name: row['first_name'], last_name: row['last_name'], employee_id: row['employee_id'], phone: row['phone'], email: row['email'],
                                       gender: row['gender'], home_company_role: row['home_company_role'], contract_start_date: row['contract_start_date'], contract_end_date: row['contract_end_date'],
                                       status: row['status'], project_id: row['project_id'], employee_type_id: row['employee_type_id'], foreman_id: row['foreman_id'],
                                       other_manager_id: row['other_manager_id'], project_company_id: row['project_company_id'], client_company_id: row['client_company_id'])
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
