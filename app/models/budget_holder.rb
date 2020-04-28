class BudgetHolder < ApplicationRecord
  audited
  has_many :cost_codes
  belongs_to :employee
  belongs_to :project

  validates_uniqueness_of :employee_id, :scope => :project_id

  def self.import_file(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      @budget_holders = []
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

          budget_holder = project.budget_holders.find_by_employee_id(employee.id)
          if budget_holder.present?
            return error = "Validation Failed. Budget Holder already exist, Error on Row: #{i}"
          end
          unless @budget_holders.any? {|budget_holder| budget_holder.employee_id == employee.id}
            @budget_holders << project.budget_holders.new(employee_id: employee.id)
          end
        rescue => e
          return e.message
        end
      end
      if @budget_holders.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      BudgetHolder.import @budget_holders
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
