module DJ
  class Worker
    
    def failure_with_hoptoad(job, error)
      HoptoadNotifier.notify_or_ignore(error, :cgi_data => self.attributes)
      failure_without_hoptoad(job, error)
    end
    
    alias_method_chain :failure, :hoptoad
    
  end
end