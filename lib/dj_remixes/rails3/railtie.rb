module DJ
  class Railtie < Rails::Railtie

    initializer "dj.configure_rails_initialization" do
      ActiveSupport.on_load(:action_mailer) do
        require File.join(File.dirname(__FILE__), 'action_mailer')
      end
    end
  end
end