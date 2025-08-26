# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
 def show?
    record.published? || user&.admin? || record.user_id == user&.id
  end

  def create? = user.present?
  def update? = user&.admin? || record.user_id == user&.id
  def destroy? = update?

  class Scope < Scope
    def resolve
      return scope.all if user&.admin?
      scope.published
    end
  end
end
