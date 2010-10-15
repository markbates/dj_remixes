if Object.const_defined?(:HoptoadNotifier)
  module DJ
    class Worker
    
      # Report Errors to Hoptoad:
      def error_with_hoptoad(job, error)
        HoptoadNotifier.notify_or_ignore(error, :cgi_data => self.dj_object.attributes)
        error_without_hoptoad(job, error)
      end
    
      alias_method_chain :error, :hoptoad
    
    end # Worker
  end # DJ
end # defined?