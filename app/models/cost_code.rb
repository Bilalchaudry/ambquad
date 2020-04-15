class CostCode < ApplicationRecord
  audited
  belongs_to :project, optional: true
  belongs_to :budget_holder, optional: true

  validates_uniqueness_of :cost_code_id

  def self.import(file, user, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        cost_code = CostCode.create(cost_code_id: row[0], cost_code_description: row[1], project_id: project.id)
      end
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            cost_code = CostCode.create(cost_code_id: row['cost_code_id'], cost_code_description: row['cost_code_description'], project_id: project.id, client_company_id: user.client_company.id)
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
