class Employee < ApplicationRecord
  audited
  validates :phone, :email, uniqueness: true
  # belongs_to :project_company, optional: true

  belongs_to :client_company
  belongs_to :project_company
  belongs_to :project
  belongs_to :employee_type
  belongs_to :foreman, optional: true
  belongs_to  :other_managers, optional: true
  has_many :project_employees
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

          if row[0].nil? || row[1].nil? || row[2].nil? || row[3].nil? || row[4].nil? || row[5].nil? || row[6].nil? || row[7].nil? || row[8].nil? || row[9].nil? || row[10].nil? || row[11].nil? || row[12].nil?
            return error = "Validation Failed Employee Field Empty in File, Error on Row: #{i}"
          end

          if row[11] == 'm' || row[11] == 'M' || row[11] == 'Male' || row[11] == 'male'
            row[11] = "Male"
          elsif row[11] == 'f' || row[11] == 'F' || row[11] == 'Female' || row[11] == 'female'
            row[11] = "Female"
          else
            row[11] = "Male"
          end

          if row[12] == 'Active' || row[12] == 'a' || row[12] == 'A' || row[12] == 'active'
            row[12] = "Active"
          elsif row[12] == 'Closed' || row[12] == 'closed' || row[12] == 'c' || row[12] == 'c' || row[12] == 'close' || row[12] == 'Close'
            row[12] = "Closed"
          elsif row[12] == 'Onhold' || row[12] == 'onhold' || row[12] == 'o' || row[12] == 'O' || row[12] == 'OnHold' || row[12] == 'onHold'
            row[12] = "Onhold"
          else
            row[12] = "Active"
          end

          id_project_company = ProjectCompany.where(company_name: row[3]).first
          if id_project_company.nil?
            return error = "Validation Failed Project Company must Exist, Error on Row: #{i}"
          else
            row[3] = id_project_company.id
           end

          exist_employee_email = project.employees.where(email: row[10])
          if !exist_employee_email.empty?
            return error = "Validation Failed Email Already Exist, Error on Row: #{i}"
          end

          new_employee_email = @employee.any? { |a| a.email == row[10] }
          if new_employee_email == true
            return error = "Validation Failed Email Already Exist in File, Error on Row: #{i}"
          end

          exist_employee_phone = project.employees.where(phone: row[9])
          if !exist_employee_phone.empty?
            return error = "Validation Failed Phone Already Exist, Error on Row: #{i}"
          end

          new_employee_phone = @employee.any? { |a| a.phone == row[9] }
          if new_employee_phone == true
            return error = "Validation Failed Phone Already Exist in File, Error on Row: #{i}"
          end

          name_other_manager = Employee.where(employee_name: row[8]).first
          if name_other_manager.nil?
            return error = "Validation Failed Other Manager must Exist, Error on Row: #{i}"
          else
            id_other_manager = OtherManager.where(employee_id: name_other_manager.id).first
            if id_other_manager.nil?
              return error = "Validation Failed Other Manager must Exist, Error on Row: #{i}"
            else
              row[8] = id_other_manager.id
            end
          end

          name_foreman = Employee.where(employee_name: row[7]).first
          if name_foreman.nil?
            return error = "Validation Failed Foreman must Exist, Error on Row: #{i}"
          else
            id_foreman = Foreman.where(employee_id: name_foreman.id).first
            if id_foreman.nil?
              return error = "Validation Failed Foreman must Exist, Error on Row: #{i}"
            else
              row[7] = id_foreman.id
            end
          end

          id_plant_type = EmployeeType.where(employee_type: row[2]).first
          if id_plant_type.nil?
            return error = "Validation Failed Employee Type must Exist, Error on Row: #{i}"
          else
            row[2] = id_plant_type.id
          end

          @employee << project.employees.new(employee_name: row[0], employee_id: row[1], employee_type_id: row[2], project_company_id: row[3], home_company_role: row[4], contract_start_date: row[5],
                                             contract_end_date: row[6], foreman_id: row[7], other_manager_id: row[8], phone: row[9], email: row[10], gender: row[11],
                                             status: row[12], client_company_id: user.client_company_id)
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
