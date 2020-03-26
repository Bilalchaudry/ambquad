class Employee < ApplicationRecord
  belongs_to :project_company, optional: true
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
        employee = Employee.create(first_name: row[0], last_name: row[1], employee_id: row[2], phone: row[3], email: row[4], gender: row[5], home_company_role: row[6],
                                   contract_start_date: row[7], contract_end_date: row[8], status: row[9], project_id: row[10], employee_type_id: row[11],
                                   foreman_id: row[12], other_manager_id: row[13], project_company_id: row[14], client_company_id: user.client_company_id)
      end
    else
      spreadsheet = open_spreadsheet(file)
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
      raise "Unknown file type: #{file.original_filename}"
    end
  end

end
