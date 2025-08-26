# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def show?
    record.published? || user&.admin? || record.user_id == user&.id
  end

  def create?
    user.present?
  end

  def update?
    user&.admin? || record.user_id == user&.id
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.admin?

      scope.published
    end
  end
end
