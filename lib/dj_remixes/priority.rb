module DJ
  class Worker
    
    # A helpful list of symbols to priority levels
    PRIORITY_LEVELS = {:urgent => -100000, :immediate => -10000, :high => -1000, :medium => -500, :normal => 0, :low => 100, :who_cares => 1000}
    
    attr_accessor :priority
    
    class << self
      
      def priority(level = 0)
        define_method('priority') do
          if level.is_a?(Symbol)
            level = DJ::Worker::PRIORITY_LEVELS[level] ||= 0
          end
          return @priority ||= level
        end
      end
      
    end
    
    def priority
      case @priority
      when Symbol
        DJ::Worker::PRIORITY_LEVELS[@priority] ||= 0
      when Fixnum
        @priority
      else
        0
      end
    end
    
  end
end