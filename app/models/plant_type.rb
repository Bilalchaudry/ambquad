class PlantType < ApplicationRecord

  belongs_to :project

  validates_uniqueness_of :type_name, :scope => :project_id


  def self.import(file, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        employee = PlantType.create(type_name: row[0], project_id: project.id)
      end
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            employee = PlantType.create(type_name: row['type_name'], project_id: project.id)
            employee.save!
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
