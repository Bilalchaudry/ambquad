
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.role.eql?("Admin")
        can :manage, :all
      else
        can [:read, :update], Project
        can :manage, [Employee, ProjectEmployee, CostCode, OtherManager, Plant, BudgetHolder,
                      EmployeeType, ProjectCompany, Foreman, PlantType, ProjectCompany]
      end
    end
  end
end
