class Foreman < ApplicationRecord
  audited
  # belongs_to :employee
  belongs_to :project
  # belongs_to :crew

  validates_uniqueness_of :employee_id, :scope => :project_id

  def self.import_file(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      @foremen = []
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

          foreman = project.foremen.find_by_employee_id(employee.id)
          if foreman.present?
            return error = "Validation Failed. Foreman already exist, Error on Row: #{i}"
          end

          unless @foremen.any? {|foreman| foreman.employee_id == employee.id}
            @foremen << project.foremen.new(employee_id: employee.id)
          end
        rescue => e
          return e.message
        end
      end
      if @foremen.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      Foreman.import @foremen
      error = 'Data imported successfully!'

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
