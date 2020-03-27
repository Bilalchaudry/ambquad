class Plant < ApplicationRecord

  validates :contract_start_date, :contract_end_date, presence: true
  validate :contract_end_date_after_contract_start_date
  validate :start_date_equar_or_greater_today_date

  def contract_end_date_after_contract_start_date
    if contract_end_date < contract_start_date
      errors.add(:contract_end_date, "must be after start date.")
    end
  end

  def start_date_equar_or_greater_today_date
    if contract_start_date < Date.today
      errors.add(:contract_start_date, "can't be in the past.")
    end
  end

  def self.import(file)
    if File.extname(file.original_filename) == '.csv'
      file_name = file.original_filename
      CSV.foreach("public/documents/#{file_name}", headers: true) do |row|
        employee = Plant.create(plant_name: row[0], plant_id: row[1], contract_start_date: row[2], foreman_start_date: row[2], contract_end_date: row[3], foreman_end_date: row[3],
                                plant_type_id: row[4], foreman_id: row[5], other_manager_id: row[6], market_value: row[7], project_id: row[8])
      end
    else
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        begin
          row = Hash[[header, spreadsheet.row(i)].transpose]
          employee = Plant.create(plant_name: row['plant_name'], plant_id: row['plant_id'], contract_start_date: ['contract_start_date'],
                                  contract_end_date: ['contract_end_date'], plant_type_id: ['plant_type_id'], foreman_id: row['foreman_id'],
                                  other_manager_id: ['other_manager_id'], market_value: row['market_value'])
          employee.save!
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
