class OtherManager < ApplicationRecord
  audited
  # belongs_to :employee
  belongs_to :project

  validates_uniqueness_of :employee_id, :scope => :project_id

  def self.import_file(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      @other_managers = []
      i = 0
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        begin
          i = i + 1

          if row[0].nil?
            return error = "Validation Failed. Employee Name Empty in File, Error on Row: #{i}"
          end

          employee = Employee.find_by_employee_name(row[0].strip)
          if employee.nil?
            return error = "Validation Failed. Employee must exist, Error on Row: #{i}"
          end

          other_manager = project.other_managers.find_by_employee_id(employee.id)
          if other_manager.present?
            return error = "Validation Failed. Other Manager already exist, Error on Row: #{i}"
          end

          unless @other_managers.any? {|other_managers| other_managers.employee_id == employee.id}
            @other_managers << project.other_managers.new(employee_id: employee.id)
          end

        rescue => e
          return e.message
        end
      end
      if @other_managers.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      OtherManager.import @other_managers
      error = 'File Import Successfully'

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
