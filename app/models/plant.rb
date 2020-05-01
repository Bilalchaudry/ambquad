class Plant < ApplicationRecord
  audited

  belongs_to :client_company
  belongs_to :project_company
  belongs_to :project
  belongs_to :plant_type
  belongs_to :foreman, optional: true
  belongs_to :other_manager, optional: true
  has_many :crew
  has_many :plant_time_sheets

  validates_uniqueness_of :plant_id, :scope => :project_id, :case_sensitive => false
  # validates :plant_id, presence: true, uniqueness: {message: "ID already taken"}

  auto_strip_attributes :plant_id

  enum status: {
      Active: 0,
      Inactive: 1,
      Onhold: 2
  }


  def contract_end_date_after_contract_start_date
    if contract_end_date < contract_start_date
      errors.add(:contract_end_date, "must be after start date.")
    end
    if contract_start_date < Date.today
      errors.add(:contract_start_date, "can't be in the past.")
    end
  end

  def start_date_equar_or_greater_today_date
    if contract_start_date < Date.today
      errors.add(:contract_start_date, "can't be in the past.")
    end
  end

  def self.import_file(file, project)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      csv_text = File.read(file.path)
      csv = CSV.parse(csv_text, :headers => true)
      i = 0
      @plant = []
      csv.each do |row|
        begin
          i = i + 1

          if row[0].nil? || row[1].nil? || row[2].nil? || row[3].nil? || row[4].nil? || row[5].nil? || row[9].nil?
            return error = "Validation Failed. Plant Field Empty in File, Error on Row: #{i}"
          end

          # exist_plant_name = Plant.where(plant_name: row[0].strip, project_id: project.id).first
          # if exist_plant_name.present?
          #   return error = "Validation Failed. Plant Name Exist, Error on Row: #{i}"
          # end

          # plant_name = @plant.any? {|a| a.plant_name == row[0].strip}
          # if plant_name
          #   return error = "Validation Failed. Plant Name Already Exist in File, Error on Row: #{i}"
          # end

          exist_employee_id = project.plants.where(plant_id: row[1].strip).first
          if exist_employee_id.present?
            return error = "Validation Failed. Plant ID Exist, Error on Row: #{i}"
          end


          plant_id = @plant.any? {|a| a.plant_id.downcase == row[1].strip.downcase}
          if plant_id
            return error = "Validation Failed. Plant ID Already Exist in File, Error on Row: #{i}"
          end


          if !(project.start_date..project.end_date).cover?(Date.parse(row[4])) || !(project.start_date..project.end_date).cover?(Date.parse(row[5]))
            return error = "Validation Failed. Date should be subset of project start and end date, Error on Row: #{i}"
          end

          if Date.parse(row[4]) > Date.parse(row[5])
            return error = "Validation Failed. Contract End date must be after start date, Error on Row: #{i}"
          end

          plant_type = project.plant_types.where(type_name: row[2].strip).first
          if plant_type.nil?
            return error = "Validation Failed. Plant Type must Exist, Error on Row: #{i}"
          else
            row[2] = plant_type.id
          end

          project_company = project.project_companies.where("lower(company_name) = ?", row[3].strip.downcase).first
          if project_company.nil?
            return error = "Validation Failed. Project Company must Exist, Error on Row: #{i}"
          else
            row[3] = project_company.id
          end

          if row[6].present?
            name_foreman = Employee.where(employee_name: row[6].strip).first
            if name_foreman.nil?
              return error = "Validation Failed.Foreman must Exist, Error on Row: #{i}"
            else
              id_foreman = Foreman.where(employee_id: name_foreman.id).first
              if id_foreman.nil?
                return error = "Validation Failed. Foreman must Exist, Error on Row: #{i}"
              else
                row[6] = id_foreman.id
              end
            end
          end

          if row[7].present?
            name_other_manager = Employee.where(employee_name: row[7].strip).first
            if name_other_manager.nil?
              # return error = "Validation Failed Other Manager must Exist, Error on Row: #{i}"
            else
              id_other_manager = OtherManager.where(employee_id: name_other_manager.id).first
              if id_other_manager.nil?
                # return error = "Validation Failed Other Manager must Exist, Error on Row: #{i}"
              else
                row[7] = id_other_manager.id
              end
            end
          end

          if row[9] == 'Active' || row[9] == 'a' || row[9] == 'A' || row[9] == 'active'
            row[9] = "Active"
          elsif row[9] == 'Closed' || row[9] == 'closed' || row[9] == 'c' || row[9] == 'c' || row[9] == 'close' || row[9] == 'Close'
            row[9] = "Closed"
          elsif row[9] == 'Onhold' || row[9] == 'onhold' || row[9] == 'o' || row[9] == 'O' || row[9] == 'OnHold' || row[9] == 'onHold'
            row[9] = "Onhold"
          else
            row[9] = "Active"
          end

          @plant << project.plants.new(plant_name: row[0], plant_id: row[1], plant_type_id: row[2], project_company_id: row[3], contract_start_date: row[4], contract_end_date: row[5],
                                       foreman_id: row[6], other_manager_id: row[7], market_value: row[8], status: row[9], foreman_start_date: row[4], foreman_end_date: row[5],
                                       client_company_id: project.client_company_id, foreman_start_date: row[4])
        rescue => e
          e.message
        end
      end
      if @plant.empty?
        return error = "Validation Failed. Please Insert some valid data in File."
      end
      Plant.import @plant
      error = 'Data imported successfully!'
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
