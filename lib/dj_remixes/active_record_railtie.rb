module DJ
  class ActiveRecordRailtie < Rails::Railtie

    initializer "dj.configure_active_record_initialization" do
      ActiveSupport.on_load(:active_record) do
        Delayed::Worker.guess_backend
        
        require File.join(File.dirname(__FILE__), 'requires')
      end
    end
  end
end