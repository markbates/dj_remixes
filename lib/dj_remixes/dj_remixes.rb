module DJ
  
  class << self
    
    def method_missing(sym, *args, &block)
      Delayed::Worker.backend.send(sym, *args, &block)
    end
    
  end
  
end