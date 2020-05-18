class Employee < ApplicationRecord
  audited

  belongs_to :client_company
  belongs_to :project_company
  belongs_to :project
  belongs_to :employee_type
  belongs_to :foreman, optional: true
  belongs_to :other_manager, optional: true
  has_many :budget_holders
  has_many :crews
  has_many :employee_time_sheets


  validates_uniqueness_of :employee_id, :scope => :project_id, :case_sensitive => false
  auto_strip_attributes :employee_id

  enum gender: {
      Male: 0,
      Female: 1
  }
  enum status: {
      Active: 0,
      Onhold: 1,
      Closed: 2
  }

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
            return error = "Validation Failed. Employee Field Empty in File, Error on Row: #{i}"
          end


          exist_employee_id = Employee.where(employee_id: row[1].strip, project_id: project.id).first
          if exist_employee_id.present?
            return error = "Validation Failed. Employee ID Exist, Error on Row: #{i}"
          end


          employee_id = @employee.any? {|a| a.employee_id.downcase == row[1].strip.downcase}
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
            exist_employee_email = Employee.where(email: row[10].strip, project_id: project.id)
            if !exist_employee_email.empty?
              return error = "Validation Failed. Email Already Exist, Error on Row: #{i}"
            end
          end

          start_date = Date.strptime(row[5],"%d/%m/%y") rescue nil
          if start_date.nil?
            start_date = Date.strptime(row[5],"%d.%m.%y") rescue nil
          end
          if start_date.nil?
            start_date = Date.parse(row[5])
          end
          end_date = Date.strptime(row[6],"%d/%m/%y") rescue nil
          if end_date.nil?
            end_date = Date.strptime(row[6],"%d.%m.%y") rescue nil
          end
          if end_date.nil?
            end_date = Date.parse(row[6])
          end
          if !(project.start_date..project.end_date).cover?(start_date) || !(project.start_date..project.end_date).cover?(end_date)
            return error = "Validation Failed. Date should be subset of project start and end date, Error on Row: #{i}"
          end

          if start_date > end_date
            return error = "Validation Failed. Contract End date must be after start date, Error on Row: #{i}"
          end

          if row[10].present?
            new_employee_email = @employee.any? {|a| a.email == row[10].strip}
            if new_employee_email == true
              return error = "Validation Failed. Email Already Exist in File, Error on Row: #{i}"
            end
          end

          if row[9].present?
            exist_employee_phone = Employee.where(phone: row[9].strip, project_id: project.id)
            if !exist_employee_phone.empty?
              return error = "Validation Failed. Phone Already Exist, Error on Row: #{i}"
            end
          end

          if row[9].present?
            new_employee_phone = @employee.any? {|a| a.phone == row[9].strip}
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

          @employee << project.employees.new(employee_name: row[0], employee_id: row[1], employee_type_id: row[2], project_company_id: row[3], home_company_role: row[4], contract_start_date: start_date,
                                             contract_end_date: end_date, foreman_id: row[7], other_manager_id: row[8], phone: row[9], email: row[10], gender: row[11],
                                             status: row[12], client_company_id: project.client_company_id,
                                             foreman_start_date: start_date)

        rescue => e
          return e.message
        end
      end

      if @employee.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      @employee.each do |employee|
        project_company = ProjectCompany.find_by_id(employee.project_company_id)
        project_company.update(number_of_employee: project_company.number_of_employee + 1) if project_company.present?
      end

      Employee.import @employee
      error = 'Data imported successfully!'
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

end
