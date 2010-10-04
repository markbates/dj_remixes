module DJ
  
  class << self
    
    # Pass off calls to the backend:
    def method_missing(sym, *args, &block)
      Delayed::Worker.backend.send(sym, *args, &block)
    end
    
  end
  
end
