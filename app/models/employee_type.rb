class EmployeeType < ApplicationRecord

  belongs_to :project

  validates :employee_type, presence: true, uniqueness: true

  def self.import(file)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        employee = EmployeeType.create(employee_type: row[0], project_id: row[1])
      end
    else
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        begin
          row = Hash[[header, spreadsheet.row(i)].transpose]
          employee_type = EmployeeType.create(employee_type: row['employee_type'])
          employee_type.save!
        end
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
      raise "Unknown file type: #{file.original_filename}"
    end
  end

end
