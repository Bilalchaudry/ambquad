class ClientCompany < ApplicationRecord

  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :project_companies, dependent: :destroy
  has_many :cost_codes, dependent: :destroy

  validates :phone, :address, :number_of_users, presence: true
  validates :company_name, :phone, uniqueness: true

  before_destroy :check_for_projects, prepend: true

  private

  def check_for_projects
    if projects.any?
      errors[:base] << "cannot delete submission that has already been linked"
      return false
    end
  end

end
