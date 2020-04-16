class CostCode < ApplicationRecord

  belongs_to :project, optional: true
  belongs_to :budget_holder, optional: true

  validates_uniqueness_of :cost_code_id

  def self.import_file(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      @cost_code=[]
      i=0
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        begin
          i=i+1
          budget_holder = Employee.where(first_name: row[12]).first
          if budget_holder.nil?
            row[12] = ''
          else
            row[12] = budget_holder.id
            budget_holder_id = BudgetHolder.where(employee_id: row[12]).first
            if budget_holder_id.nil?
              row[12] = ''
            else
              row[12] = budget_holder_id.id
            end
          end

          if row[0].nil?
            return error = "Validation Failed Cost Cost ID Empty in File, Error on Row: #{i}"
          end

          exist_cost_code = project.cost_codes.where(cost_code_id: row[0])
          if !exist_cost_code.empty?
            return error = "Validation Failed Cost Cost Already Exist in Project, Error on Row: #{i}"
          end

          new_cost_code = @cost_code.any?{|a| a.cost_code_id == row[0]}
          if new_cost_code == true
            return error = "Validation Failed Cost Cost Already Exist in File, Error on Row: #{i}"
          end

          @cost_code << project.cost_codes.new(cost_code_id: row[0], cost_code_description: row[1], WBS_01: row[2], WBS_01_Description: row[3],
                                                 WBS_02: row[4], WBS_02_Description: row[5], WBS_03: row[6], WBS_03_Description: row[7],
                                                 WBS_04: row[8], WBS_04_Description: row[9], WBS_05: row[10], WBS_05_Description: row[11], budget_holder_id: row[12])
        rescue => e
          return e.message
        end
      end
      CostCode.import @cost_code
      error = 'File Import Successfully'
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            cost_code = project.cost_codes.create(cost_code_id: row['cost_code_id'], cost_code_description: row['cost_code_description'],
                                                  project_id: project.id, client_company_id: user.client_company.id)
            cost_code.save!
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
