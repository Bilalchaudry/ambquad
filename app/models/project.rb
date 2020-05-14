class Project < ApplicationRecord
  audited
  belongs_to :client_company

  has_many :cost_codes, dependent: :destroy
  has_many :other_managers, dependent: :destroy
  has_many :plants, dependent: :destroy
  has_many :budget_holders, dependent: :destroy
  has_many :plant_types, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :employee_types, dependent: :destroy
  has_many :foremen, dependent: :destroy
  has_many :employee_time_sheets, dependent: :destroy
  has_many :plant_time_sheets, dependent: :destroy
  has_many :time_sheet_cost_codes, dependent: :destroy
  has_many :project_companies

  has_many :users
  has_many :crews


  enum status: {
      Active: 0,
      Onhold: 1,
      Closed: 2
  }

  validates_uniqueness_of :project_name, :case_sensitive => false
  auto_strip_attributes :project_name


  # before_destroy :check_for_projects, prepend: true

  private

  # def check_for_projects
  #   if project_employees.any? || cost_codes.any? || other_managers.any? || plants.any? || budget_holders.any? ||
  #       plant_types.any? || employee_types.any? || foremen.any?
  #     errors[:base] << "cannot delete submission that has already been linked"
  #     return false
  #   end
  # end


end
