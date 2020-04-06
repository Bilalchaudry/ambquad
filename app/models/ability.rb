class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.role.eql?("Admin")
        can :manage, :all
      else
        can [:read, :view], ClientCompany
        can [:read, :view], Project, client_company_id: user.client_company_id
        can :manage, Employee, client_company_id: user.client_company_id
        can [:read, :view, :update], User
        can :manage, ProjectEmployee
        can :manage, CostCode, client_company_id: user.client_company_id
        can :manage, OtherManager, client_company_id: user.client_company_id
        can :manage, Plant, client_company_id: user.client_company_id
        can :manage, BudgetHolder, client_company_id: user.client_company_id
        can :manage, EmployeeType
        can :manage, ProjectCompany, client_company_id: user.client_company_id
        can :manage, Foreman, client_company_id: user.client_company_id
        can :manage, PlantType, client_company_id: user.client_company_id
      end
    end
  end
end
