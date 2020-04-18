class ClientCompany < ApplicationRecord
  audited
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :project_companies, dependent: :destroy
  has_many :cost_codes, dependent: :destroy
  has_many :plants, dependent: :destroy

  validates :address, presence: true
  validates :company_name, :company_id, uniqueness: true
  # validates :phone,
  #           :numericality => true,
  #           :length => { :minimum => 5, :maximum => 15 }

  before_destroy :check_for_projects, prepend: true

  private

  def check_for_projects
    if projects.any?
      errors[:base] << "cannot delete submission that has already been linked"
      return false
    end
  end

end
