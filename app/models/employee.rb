class Employee < ApplicationRecord
  audited
  validates_uniqueness_of :email, :employee_name, :scope => :project_id, :case_sensitive => false
  validates :employee_id, presence: true, uniqueness: {message: "ID already taken"}

  auto_strip_attributes :employee_name, :employee_id

  after_create :time_sheet_employee

  belongs_to :client_company
  belongs_to :project_company
  belongs_to :project
  belongs_to :employee_type
  belongs_to :foreman, optional: true
  belongs_to :other_manager, optional: true
  has_many :project_employees
  has_many :budget_holders
  has_many :crews

  enum gender: {
      Male: 0,
      Female: 1
  }
  enum status: {
      Active: 0,
      Onhold: 1,
      Closed: 2
  }

  # validate :contract_end_date_after_contract_start_date
  # validate :start_date_equal_or_greater_today_date

  # validates :contract_end_date,
  #           date: {after: :contract_start_date}

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
      csv_text = File.read(file.path)
      csv = CSV.parse(csv_text, :headers => true)
      i = 0
      @employee = []
      csv.each do |row|
        begin
          i = i + 1

          if row[0].nil? || row[1].nil? || row[2].nil? || row[3].nil? || row[5].nil? || row[6].nil? || row[12].nil?
            return error = "Validation Failed.Employee Field Empty in File, Error on Row: #{i}"
          end

          exist_employee_name = Employee.where(employee_name: row[0].strip).first
          if exist_employee_name.present?
            return error = "Validation Failed. Employee Name Exist, Error on Row: #{i}"
          end


          employee_name = @employee.any? { |a| a.employee_name == row[0].strip }
          if employee_name
            return error = "Validation Failed. Employee Name Already Exist in File, Error on Row: #{i}"
          end


          exist_employee_id = Employee.where(employee_id: row[1].strip).first
          if exist_employee_id.present?
            return error = "Validation Failed. Employee ID Exist, Error on Row: #{i}"
          end


          employee_id = @employee.any? { |a| a.employee_id == row[1].strip }
          if employee_id
            return error = "Validation Failed. Employee ID Already Exist in File, Error on Row: #{i}"
          end

          if row[11].present?
            if row[11] == 'm' || row[11] == 'M' || row[11] == 'Male' || row[11] == 'male'
              row[11] = "Male"
            elsif row[11] == 'f' || row[11] == 'F' || row[11] == 'Female' || row[11] == 'female'
              row[11] = "Female"
            else
              row[11] = "Male"
            end
          end

          if row[12].present?
            if row[12] == 'Active' || row[12] == 'a' || row[12] == 'A' || row[12] == 'active'
              row[12] = "Active"
            elsif row[12] == 'Closed' || row[12] == 'closed' || row[12] == 'c' || row[12] == 'c' || row[12] == 'close' || row[12] == 'Close'
              row[12] = "Closed"
            elsif row[12] == 'Onhold' || row[12] == 'onhold' || row[12] == 'o' || row[12] == 'O' || row[12] == 'OnHold' || row[12] == 'onHold'
              row[12] = "Onhold"
            else
              row[12] = "Active"
            end
          end

          project_company = project.project_companies.where("lower(company_name) = ?", row[3].strip.downcase).first
          if project_company.nil?
            return error = "Validation Failed. Project Company must Exist, Error on Row: #{i}"
          else
            row[3] = project_company.id
          end

          if row[10].present?
            exist_employee_email = Employee.where(email: row[10].strip)
            if !exist_employee_email.empty?
              return error = "Validation Failed. Email Already Exist, Error on Row: #{i}"
            end
          end

          unless (project.start_date..project.end_date).cover?(Date.parse(row[5])) || (project.start_date..project.end_date).cover?(Date.parse(row[6]))
            return error = "Validation Failed. Date should be subset of project start and end date, Error on Row: #{i}"
          end

          if Date.parse(row[5]) > Date.parse(row[6])
            return error = "Validation Failed. Contract End date must be after start date, Error on Row: #{i}"
          end

          if row[10].present?
            new_employee_email = @employee.any? { |a| a.email == row[10].strip }
            if new_employee_email == true
              return error = "Validation Failed. Email Already Exist in File, Error on Row: #{i}"
            end
          end

          if row[9].present?
            exist_employee_phone = Employee.where(phone: row[9].strip)
            if !exist_employee_phone.empty?
              return error = "Validation Failed. Phone Already Exist, Error on Row: #{i}"
            end
          end

          if row[9].present?
            new_employee_phone = @employee.any? { |a| a.phone == row[9].strip }
            if new_employee_phone == true
              return error = "Validation Failed. Phone Already Exist in File, Error on Row: #{i}"
            end
          end

          if row[8].present?
            other_manager = Employee.where(employee_name: row[8].strip).first
            if other_manager.nil?
              return error = "Validation Failed. Other Manager must Exist, Error on Row: #{i}"
            else
              other_manager = OtherManager.where(employee_id: other_manager.id).first
              if other_manager.nil?
                return error = "Validation Failed. Other Manager must Exist, Error on Row: #{i}"
              else
                row[8] = other_manager.id
              end
            end
          end

          if row[7].present?
            foreman = Employee.where(employee_name: row[7].strip).first
            if foreman.nil?
              return error = "Validation Failed. Foreman must Exist, Error on Row: #{i}"
            else
              foreman = Foreman.where(employee_id: foreman.id).first
              if foreman.nil?
                return error = "Validation Failed. Foreman must Exist, Error on Row: #{i}"
              else
                row[7] = foreman.id
              end
            end
          end

          plant_type = EmployeeType.where(employee_type: row[2].strip).first
          if plant_type.nil?
            return error = "Validation Failed. Employee Type must Exist, Error on Row: #{i}"
          else
            row[2] = plant_type.id
          end

          @employee << project.employees.new(employee_name: row[0], employee_id: row[1], employee_type_id: row[2], project_company_id: row[3], home_company_role: row[4], contract_start_date: row[5],
                                             contract_end_date: row[6], foreman_id: row[7], other_manager_id: row[8], phone: row[9], email: row[10], gender: row[11],
                                             status: row[12], client_company_id: project.client_company_id,
                                             foreman_start_date: row[5])

        rescue => e
          return e.message
        end
      end
      if @employee.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      Employee.import @employee
      error = 'File Import Successfully'
    else
      error = 'Invalid File Format. Please Import CSV Successfully'

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

  def time_sheet_employee
    company = self.project_company.company_name rescue nil
    foreman_namee = Employee.find_by_id(self.foreman.employee_id).employee_name rescue nil
    other_manager = Employee.find_by_id(self.other_manager.employee_id).employee_name rescue nil
    @employee_time_sheet = EmployeeTimeSheet.create!(employee: self.employee_name,
                                                     labour_type: self.employee_type.employee_type,
                                                     project_company_id: self.project_company_id,
                                                     manager: other_manager,
                                                     foreman_name: foreman_namee,
                                                     company: company,
                                                     total_hours: 0,
                                                     employee_type_id: self.employee_type_id,
                                                     employee_id: employee_id.to_i, project_id: self.project_id,
                                                     employee_create_date: Time.now.strftime("%Y-%m-%d"))
  end
end
