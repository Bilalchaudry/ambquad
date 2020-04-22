class EmployeeType < ApplicationRecord
  audited
  belongs_to :project
  has_many :employees

  validates_uniqueness_of :employee_type, :scope => :project_id, :case_sensitive => false

  def self.import_file(file, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      @employee_type = []
      i = 0
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        begin
          i = i + 1

          if row[0].nil?
            return error = "Validation Failed Employee Type Empty in File, Error on Row: #{i}"
          end

          exist_employee_type = project.employee_types.where(employee_type: row[0])
          if !exist_employee_type.empty?
            return error = "Validation Failed Employee Type Already Exist in Project, Error on Row: #{i}"
          end

          new_employee_type = @employee_type.any? {|a| a.employee_type == row[0]}
          if new_employee_type == true
            return error = "Validation Failed Employee Type Already Exist in File, Error on Row: #{i}"
          end
          unless @employee_type.any? {|employee_type| employee_type.employee_id == employee.id}
            @employee_type << project.employee_types.new(employee_type: row[0], project_id: project.id)
          end

        rescue => e
          return e.message
        end
      end
      EmployeeType.import @employee_type
      error = 'File Import Successfully'
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            employee_type = EmployeeType.create(employee_type: row['employee_type'], project_id: project.id)
            employee_type.save!
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
