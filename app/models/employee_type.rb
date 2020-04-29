class EmployeeType < ApplicationRecord
  audited
  belongs_to :project
  has_many :employees

  validates_uniqueness_of :employee_type, :scope => :project_id, :case_sensitive => false
  auto_strip_attributes :employee_type

  def self.import_file(file, project)
    if File.extname(file.original_filename) == '.csv'
      csv_text = File.read(file.path)
      csv = CSV.parse(csv_text, :headers => true)
      i = 0
      @employee_type = []
      csv.each do |row|
        begin
          i = i + 1
          if row[0].nil?
            return error = "Validation Failed. Employee Type Empty in File, Error on Row: #{i}"
          end

          exist_employee_type = project.employee_types.where("lower(employee_type) = ?", row[0].strip.downcase)
          if exist_employee_type.present?
            return error = "Validation Failed. Employee Type Already Exist in Project, Error on Row: #{i}"
          end

          new_employee_type = @employee_type.any? {|a| a.employee_type.downcase == row[0].strip.downcase}
          if new_employee_type == true
            return error = "Validation Failed.Employee Type Already Exist in File, Error on Row: #{i}"
          end

          @employee_type << project.employee_types.new(employee_type: row[0].strip, project_id: project.id)

        rescue => e
          return e.message
        end
      end
      if @employee_type.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      EmployeeType.import @employee_type
      error = 'File Import Successfully'
    else
      error = 'Invalid file format. Please upload CSV file'
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
