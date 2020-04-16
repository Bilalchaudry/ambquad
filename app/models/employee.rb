class Employee < ApplicationRecord
  audited
  validates :phone, :email, uniqueness: true
  # belongs_to :project_company, optional: true

  belongs_to :client_company
  belongs_to :project_company
  belongs_to :project
  belongs_to :employee_type
  belongs_to :foreman
  has_many :project_employees
  has_many :other_managers
  has_many :budget_holders
  # has_many :employee_types

  enum gender: {
      Male: 0,
      Female: 1
  }
  enum status: {
      Active: 0,
      Onhold: 1,
      Closed: 2
  }

  validate :contract_end_date_after_contract_start_date
  validate :start_date_equal_or_greater_today_date

  def contract_end_date_after_contract_start_date
    if contract_end_date < contract_start_date
      errors.add(:contract_end_date, "must be after start date.")
    end
    if contract_start_date < Date.today
      errors.add(:contract_start_date, "can't be in the past.")
    end
  end

  def start_date_equal_or_greater_today_date
    if contract_start_date < Date.today
      errors.add(:contract_start_date, "can't be in the past.")
    end
  end


  def self.import_file(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      i = 0
      @employee = []
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        begin
          i = i + 1

          if row[0].nil? || row[1].nil? || row[2].nil? || row[3].nil? || row[4].nil? || row[5].nil? || row[6].nil? || row[7].nil? || row[8].nil? || row[9].nil? || row[10].nil? || row[11].nil?
            return error = "Validation Failed Employee Field Empty in File, Error on Row: #{i}"
          end

          if row[6] == 'm' || row[6] == 'M' || row[6] == 'Male' || row[6] == 'male'
            row[6] = "Male"
          elsif row[6] == 'f' || row[6] == 'F' || row[6] == 'Female' || row[6] == 'female'
            row[6] = "Female"
          else
            row[6] = "Male"
          end

          if row[10] == 'Active' || row[10] == 'a' || row[10] == 'A' || row[10] == 'active'
            row[10] = "Active"
          elsif row[10] == 'Closed' || row[10] == 'closed' || row[10] == 'c' || row[10] == 'c' || row[10] == 'close' || row[10] == 'Close'
            row[10] = "Closed"
          elsif row[10] == 'Onhold' || row[10] == 'onhold' || row[10] == 'o' || row[10] == 'O' || row[10] == 'OnHold' || row[10] == 'onHold'
            row[10] = "Onhold"
          else
            row[10] = "Active"
          end

          id_project_company = ProjectCompany.where(company_name: row[11]).first
          if id_project_company.nil?
            return error = "Validation Failed Project Company must Exist, Error on Row: #{i}"
          else
            row[11] = id_project_company.id
           end

          exist_employee_email = project.employees.where(email: row[5])
          if !exist_employee_email.empty?
            return error = "Validation Failed Email Already Exist, Error on Row: #{i}"
          end

          new_employee_email = @employee.any? { |a| a.email == row[05] }
          if new_employee_email == true
            return error = "Validation Failed Email Already Exist in File, Error on Row: #{i}"
          end

          exist_employee_phone = project.employees.where(phone: row[5])
          if !exist_employee_phone.empty?
            return error = "Validation Failed Email Already Exist, Error on Row: #{i}"
          end

          new_employee_phone = @employee.any? { |a| a.email == row[05] }
          if new_employee_phone == true
            return error = "Validation Failed Email Already Exist in File, Error on Row: #{i}"
          end

          @employee << project.employees.new(first_name: row[0], last_name: row[1], employee_id: row[2], country_name: row[3], phone: row[4], email: row[5],
                                             gender: row[6], home_company_role: row[7], contract_start_date: row[8], contract_end_date: row[9], status: row[10],
                                             project_company_id: row[11], client_company_id: user.client_company_id)
        rescue => e
          return e.message
        end
      end
      Employee.import @employee
      error = 'File Import Successfully'
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
