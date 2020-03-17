class Plant < ApplicationRecord
  validates_uniqueness_of :plant_name
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
end
