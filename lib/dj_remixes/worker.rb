module DJ
  class Worker
    
    PRIORITY_LEVELS = {:immediate => 10000, :high => 1000, :medium => 500, :normal => 0, :low => -100, :who_cares => -1000}
    
    attr_accessor :run_at
    attr_accessor :priority
    attr_accessor :worker_class_name
    attr_accessor :re_enqueuable
    attr_accessor :id
    attr_accessor :attributes
    attr_accessor :dj_object
    
    class << self
      
      def priority(level = 0)
        define_method('priority') do
          if level.is_a?(Symbol)
            level = DJ::Worker::PRIORITY_LEVELS[level] ||= 0
          end
          return @priority ||= level
        end
      end
      
      def is_unique
        define_method('unique?') do
          return true
        end
      end
      
      def enqueue(*args)
        self.new(*args).enqueue
      end
      
      def re_enqueue(&block)
        define_method('re_enqueuable') do
          true
        end
        define_method('__re_enqueue_block') do
          block
        end
      end
      
    end
    
    def initialize(attributes = {})
      self.attributes = attributes
      self.attributes = self.attributes.stringify_keys
      self.id = self.attributes['id']
    end
    
    def method_missing(sym, *args, &block)
      attribute = sym.to_s
      case attribute
      when /(.+)\=$/
        self.attributes[$1] = args.first
      when /(.+)\?$/
        # self.attributes.has_key?($1.to_sym)
        return self.attributes[$1]
      else
        return self.attributes[attribute]
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

    def run_at
      return @run_at ||= Time.now
    end
    
    def dj_object=(dj)
      @dj_object = dj.id
    end
    
    def dj_object
      DJ.find(@dj_object)
    end
    
    def worker_class_name
      if self.id
        @worker_class_name ||= File.join(self.class.to_s.underscore, self.id.to_s)
      else
        @worker_class_name ||= self.class.to_s.underscore
      end
    end
    
    def enqueue(priority = self.priority, run_at = self.run_at)
      job = DJ.enqueue(self, priority, run_at)
      job.worker_class_name = self.worker_class_name
      job.save
      return job
    end
    
    alias_method :save, :enqueue
    
    def unique?
      false
    end
    
    def clone
      cl = super
      cl.run_at = nil
      cl
    end
    
    def before(job)
      self.dj_object = job
      job.touch(:started_at)
    end
    
    def perform
      raise NoMethodError.new('perform')
    end
    
    def after(job)
    end
    
    def success(job)
      job.touch(:finished_at)
      enqueue_again
    end
    
    def failure(job, error)
      job.update_attributes(:started_at => nil)
    end
    
    def enqueue_again
      if self.re_enqueuable
        new_worker = self.clone()
        if self.__re_enqueue_block
          self.__re_enqueue_block.call(self, new_worker)
        end
        new_worker.enqueue
      end
    end
    
  end
end