class ClientCompany < ApplicationRecord
  audited
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :project_companies, dependent: :destroy
  has_many :cost_codes, dependent: :destroy
  has_many :plants, dependent: :destroy

  validates :address, presence: true
  validates_uniqueness_of :company_name, :company_id, :case_sensitive => false
  validates :company_id, presence: true, uniqueness: {message: "ID already taken"}


  auto_strip_attributes :company_name, :company_id

  before_destroy :check_for_projects, prepend: true

  private

  def check_for_projects
    if projects.any?
      errors[:base] << "cannot delete submission that has already been linked"
      return false
    end
  end

end
