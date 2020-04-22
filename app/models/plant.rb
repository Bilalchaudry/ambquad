class Plant < ApplicationRecord
  audited

  belongs_to :client_company
  belongs_to :project_company
  belongs_to :project
  belongs_to :plant_type
  belongs_to :foreman, optional: true
  belongs_to :other_manager, optional: true
  has_many :crew

  enum status: {
      Active: 0,
      Inactive: 1,
      Onhold: 2
  }


  # validates :contract_start_date, :contract_end_date, presence: true
  validate :contract_end_date_after_contract_start_date
  validate :start_date_equar_or_greater_today_date

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
      i = 0
      @plant = []
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        begin
          i = i + 1


          if row[0].nil? || row[1].nil? || row[2].nil? || row[3].nil? || row[4].nil? || row[5].nil? || row[6].nil? || row[7].nil? || row[8].nil? || row[9].nil?
            return error = "Validation Failed Plant Field Empty in File, Error on Row: #{i}"
          end

          id_plant_type = PlantType.where(type_name: row[2].strip).first
          if id_plant_type.nil?
            return error = "Validation Failed Plant Type must Exist, Error on Row: #{i}"
          else
            row[2] = id_plant_type.id
          end

          id_project_company = ProjectCompany.where(company_name: row[3].strip).first
          if id_project_company.nil?
            return error = "Validation Failed Project Company must Exist, Error on Row: #{i}"
          else
            row[3] = id_project_company.id
          end

          name_foreman = Employee.where(first_name: row[6].strip).first
          if name_foreman.nil?
            return error = "Validation Failed Foreman must Exist, Error on Row: #{i}"
          else
            id_foreman = Foreman.where(employee_id: name_foreman.id).first
            if id_foreman.nil?
              return error = "Validation Failed Foreman must Exist, Error on Row: #{i}"
            else
              row[6] = id_foreman.id
            end
          end

          name_other_manager = Employee.where(first_name: row[7].strip).first
          if name_other_manager.nil?
            return error = "Validation Failed Other Manager must Exist, Error on Row: #{i}"
          else
            id_other_manager = OtherManager.where(employee_id: name_other_manager.id).first
            if id_other_manager.nil?
              return error = "Validation Failed Other Manager must Exist, Error on Row: #{i}"
            else
              row[7] = id_other_manager.id
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

            @plant << Plant.new(plant_name: row[0], plant_id: row[1], plant_type_id: row[2], project_company_id: row[3], contract_start_date: row[4], contract_end_date: row[5],
                                foreman_id: row[6], other_manager_id: row[7], market_value: row[8], status: row[9], foreman_start_date: row[4], foreman_end_date: row[5],
                                project_id: project.id, client_company_id: project.client_company_id)
        rescue => e
          e.message
        end
      end
      Plant.import @plant
      error = 'File Import Successfully'
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet != false
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            employee = Plant.create(plant_name: row['plant_name'], plant_id: row['plant_id'], contract_start_date: ['contract_start_date'],
                                    contract_end_date: ['contract_end_date'], plant_type_id: ['plant_type_id'], foreman_id: row['foreman_id'],
                                    other_manager_id: ['other_manager_id'], market_value: row['market_value'], project_id: project.id)
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
