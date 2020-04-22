class PlantType < ApplicationRecord
  audited
  belongs_to :project
  has_many :plants

  validates_uniqueness_of :type_name, :scope => :project_id, :case_sensitive => false


  def self.import_file(file, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      i = 0
      @plant_type = []
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        begin
          i = i + 1

          if row[0].nil?
            return error = "Validation Failed Plant Type Empty in File, Error on Row: #{i}"
          end

          exist_plant_type = project.plant_types.where(type_name: row[0])
          if !exist_plant_type.empty?
            return error = "Validation Failed Plant Type Already Exist in Project, Error on Row: #{i}"
          end

          new_plant_type = @plant_type.any? {|a| a.type_name == row[0]}
          if new_plant_type == true
            return error = "Validation Failed Plant Type Already Exist in File, Error on Row: #{i}"
          end

            @plant_type << project.plant_types.new(type_name: row[0], project_id: project.id)

        rescue => e
          return e.message
        end
      end
      PlantType.import @plant_type
      error = 'File Import Successfully'
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            employee = project.plant_types.create(type_name: row['type_name'], project_id: project.id)
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
