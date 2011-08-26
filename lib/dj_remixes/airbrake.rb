if Object.const_defined?(:Airbrake)
  module DJ
    class Worker
    
      # Report Errors to Airbrake:
      def error_with_airbrake(job, error)
        Airbrake.notify_or_ignore(error, :cgi_data => self.dj_object.attributes)
        error_without_airbrake(job, error)
      end
    
      alias_method_chain :error, :airbrake
    
    end # Worker
  end # DJ
end # defined?