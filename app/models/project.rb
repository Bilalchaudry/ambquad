class Project < ApplicationRecord

  belongs_to :client_company

  has_many :cost_codes, dependent: :destroy
  has_many :other_managers, dependent: :destroy
  has_many :plants, dependent: :destroy
  has_many :budget_holders, dependent: :destroy
  has_many :plant_types, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :employee_types, dependent: :destroy
  has_many :foremen, dependent: :destroy
  has_many :project_plants, dependent: :destroy

  has_many :users, :through => :user_projects

  has_many :project_and_project_companies
  has_many :project_companies, :through => :project_and_project_companies

  has_many :project_project_employees
  has_many :project_employees, :through => :project_project_employees

  validates_uniqueness_of :project_name

  before_destroy :check_for_projects, prepend: true

  private

  def check_for_projects
    if project_employees.any? || cost_codes.any? || other_managers.any? || plants.any?  || budget_holders.any? ||
        plant_types.any? || employee_types.any? || foremen.any?
      errors[:base] << "cannot delete submission that has already been linked"
      return false
    end
  end


end
