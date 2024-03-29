class ProjectCompany < ApplicationRecord
  audited
  has_many :employees, dependent: :destroy
  has_many :plants
  has_many :employee_time_sheets
  has_many :plant_time_sheets
  belongs_to :client_company
  belongs_to :project


  validates_uniqueness_of :company_name, :scope => :project_id, :case_sensitive => false
  auto_strip_attributes :company_name

  def self.import_file(file, user, project)

    if File.extname(file.original_filename) == '.csv'
      csv_text = (File.read(file.path, :encoding => 'windows-1251:utf-8')).scrub
      csv = CSV.parse(csv_text, :headers => true)
      i = 0
      @project_company = []
      csv.each do |row|
        begin
          i = i + 1

          if row[0].nil? || row[3].nil?
            return error = "Validation Failed. there is Empty Field in File, Error on Row: #{i}"
          end

          exist_project_company = project.project_companies.where("lower(company_name) = ?", row[0].strip.downcase)
          if exist_project_company.present?
            return error = "Validation Failed. Project Company Already Exist in Project, Error on Row: #{i}"
          end

          new_project_company = @project_company.any? {|a| a.company_name.downcase == row[0].strip.downcase}
          if new_project_company == true
            return error = "Validation Failed. Project Company Already Exist in File, Error on Row: #{i}"
          end

          @project_company << project.project_companies.new(company_name: row[0], company_summary: row[1], project_role: row[2], address: row[3], country_name: row[4], phone: row[5],
                                                            primary_poc_first_name: row[6], primary_poc_last_name: row[7], poc_email: row[8], poc_country: row[9], poc_phone: row[10],
                                                            client_company_id: project.client_company.id, project_id: project.id)
        rescue => e
          e.message
        end
      end
      if @project_company.empty?
        return error = "Validation Failed. Please Insert some data in File."
      end
      ProjectCompany.import @project_company
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