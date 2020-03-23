class CostCode < ApplicationRecord

  belongs_to :project, optional: true

  validates_uniqueness_of :cost_code_id

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      begin
        row = Hash[[header, spreadsheet.row(i)].transpose]
        cost_code = CostCode.create(cost_code_id: row['cost_code_id'], cost_code_description: row['cost_code_description'], project_id: row['project_id'] )
        cost_code.save!
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".xlsx" then Roo::Excelx.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end


end
