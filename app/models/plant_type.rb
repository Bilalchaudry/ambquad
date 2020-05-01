class PlantType < ApplicationRecord
  audited
  belongs_to :project
  # has_many :plants
  auto_strip_attributes :type_name
  validates_uniqueness_of :type_name, :scope => :project_id, :case_sensitive => false


  def self.import_file(file, project)
    if File.extname(file.original_filename) == '.csv'
      csv_text = File.read(file.path)
      csv = CSV.parse(csv_text, :headers => true)
      i = 0
      @plant_type = []
      csv.each do |row|
        begin
          i = i + 1

          if row[0].nil?
            return error = "Validation Failed. Plant Type Empty in File, Error on Row: #{i}"
          end

          exist_plant_type = project.plant_types.where("lower(type_name) = ?",  row[0].strip.downcase)
          if !exist_plant_type.empty?
            return error = "Validation Failed. Plant Type Already Exist in Project, Error on Row: #{i}"
          end

          new_plant_type = @plant_type.any? {|a| a.type_name.downcase == row[0].strip.downcase}
          if new_plant_type == true
            return error = "Validation Failed. Plant Type Already Exist in File, Error on Row: #{i}"
          end

          @plant_type << project.plant_types.new(type_name: row[0].strip)

        rescue => e
          return e.message
        end
      end
      if @plant_type.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      PlantType.import @plant_type
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
