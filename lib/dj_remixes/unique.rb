module DJ
  class Worker
    
    class << self
      
      # Tell DJ to only allow one of this worker at a given time.
      # 
      # Example:
      #   # We only want to charge the card once!
      #   class PurchaseWorker < DJ::Worker
      #     is_unique
      # 
      #     def perform
      #       # charge the credit card...
      #     end
      #   end
      def is_unique
        define_method('unique?') do
          return true
        end
      end
      
    end
    
    # Returns true or false based on whether this should be the only
    # worker that should be allowed in the system at any one time.
    # If set to true, using the is_unique class method, then when a 
    # new job is enqueued it will be validated against the worker_class_name
    # field in the database. If there is already a job with the same
    # worker_class_name then the enqueing of the new job will fail.
    def unique?
      false
    end
    
  end # Worker
end # DJ