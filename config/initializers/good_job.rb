# This is here to make sure non-privileged users cannot access
# the Good Job admin panel.

ActiveSupport.on_load(:good_job_application_controller) do
  include SessionsHelper

  before_action do
    raise ActionController::RoutingError.new('Not Found') unless (current_user && current_user&.admin?)
  end
end
