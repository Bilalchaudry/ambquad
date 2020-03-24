class Employee < ApplicationRecord
  belongs_to :project
  belongs_to :project_company
  enum gender: {
      Male: 0,
      Female: 1
  }
  enum status: {
      Active: 0,
      Onhold: 1,
      Closed: 2
  }

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      begin
        row = Hash[[header, spreadsheet.row(i)].transpose]
        employee = Employee.create(first_name: row['first_name'], last_name: row['last_name'], employee_id: row['employee_id'], phone: row['phone'], email: row['email'],
                                   gender: row['gender'], home_company_role: row['home_company_role'], contract_start_date: row['contract_start_date'], contract_end_date: row['contract_end_date'],
                                   status: row['status'], project_id: row['project_id'], employee_type_id: row['employee_type_id'], foreman_id: row['foreman_id'],
                                   other_manager_id: row['other_manager_id'], project_company_id: row['project_company_id'] ,client_company_id: row['client_company_id'] )
        employee.save!
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".xlsx" then Roo::Excelx.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

end
