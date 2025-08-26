# frozen_string_literal: true

module Web
  module Admin
    class ApplicationController < ::ApplicationController
      layout 'admin'
      before_action :require_admin!
    end
  end
end
