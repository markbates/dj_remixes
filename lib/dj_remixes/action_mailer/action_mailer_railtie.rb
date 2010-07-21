module DJ
  class ActionMailerRailtie < Rails::Railtie

    initializer "dj.configure_action_mailer_initialization" do
      ActiveSupport.on_load(:action_mailer) do
        require File.join(File.dirname(__FILE__), 'action_mailer')
        require File.join(File.dirname(__FILE__), 'unique_validator')
      end
    end
  end
end