module DJ
  class Worker
    
    attr_accessor :run_at
    
    class << self
      
      def run_at(&block)
        define_method('run_at', &block)
      end
      
    end
    
    def run_at
      return @run_at ||= Time.now
    end
    
  end # Worker
end # DJ