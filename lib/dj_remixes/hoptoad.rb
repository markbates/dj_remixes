if Object.const_defined?(:HoptoadNotifier)
  module DJ
    class Worker
    
      # Report Errors to Hoptoad:
      def failure_with_hoptoad(job, error)
        HoptoadNotifier.notify_or_ignore(error, :cgi_data => self.dj_object.attributes)
        failure_without_hoptoad(job, error)
      end
    
      alias_method_chain :failure, :hoptoad
    
    end # Worker
  end # DJ
end # defined?