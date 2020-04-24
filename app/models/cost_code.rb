class CostCode < ApplicationRecord
  audited
  belongs_to :project, optional: true
  belongs_to :budget_holder, optional: true

  validates_uniqueness_of :cost_code_id, :scope => :project_id, :case_sensitive => false
  auto_strip_attributes :cost_code_id


  def self.import_file(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      csv_text = File.read(file.path)
      csv = CSV.parse(csv_text, :headers => true)
      i = 0
      @cost_code = []
      i = 0
      csv.each do |row|
        begin
          i = i + 1
          if row[0].present?
            budget_holder = Employee.where(employee_name: row[0].strip).first
            if budget_holder.nil?
              return error = "Validation Failed. Budget Holder does not exist. Error on Row: #{i}"
            else
              row[0] = budget_holder.id
              budget_holder_id = BudgetHolder.where(employee_id: row[0].strip).first
              if budget_holder_id.nil?
                return error = "Validation Failed. Budget Holder does not exist. Error on Row: #{i}"
              else
                row[0] = budget_holder_id.id
              end
            end
          end

          if row[1].nil?
            return error = "Validation Failed. Cost Cost ID Empty in File, Error on Row: #{i}"
          end

          exist_cost_code = project.cost_codes.where("lower(cost_code_id) = ?", row[1].strip.downcase)
          if !exist_cost_code.empty?
            return error = "Validation Failed. Cost Cost Already Exist in Project, Error on Row: #{i}"
          end

          new_cost_code = @cost_code.any? {|cost_code| cost_code.cost_code_id == row[1]}
          if new_cost_code == true
            return error = "Validation Failed. Cost Cost Already Exist in File, Error on Row: #{i}"
          end


          # unless @cost_code.any? {|cost_code| cost_code.employee_id == employee.id}
          @cost_code << project.cost_codes.new(budget_holder_id: row[0], cost_code_id: row[1], cost_code_description: row[2], WBS_01: row[3], WBS_01_Description: row[4],
                                               WBS_02: row[5], WBS_02_Description: row[6], WBS_03: row[7], WBS_03_Description: row[8],
                                               WBS_04: row[9], WBS_04_Description: row[10], WBS_05: row[11], WBS_05_Description: row[12])
            # end
        rescue => e
          return e.message
        end
      end
      if @cost_code.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      CostCode.import @cost_code
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


end
