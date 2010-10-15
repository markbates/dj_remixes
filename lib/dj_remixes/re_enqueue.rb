module DJ
  class Worker
    
    class << self
      
      # Class level accessor to let DJ know whether it
      # should be enqueued again after it has successfully
      # completed.
      attr_accessor :re_enqueuable
      
      # A convience method to tell DJ to re-enqueue this worker
      # after it has successfully completely. NOTE: This will actually
      # create a new DJ object in the database, not reuse the same one.
      # 
      # Example:
      #   # Run every 30 days and charge a credit card.
      #   class SubscriptionWorker < DJ::Worker
      #     re_enqueue
      #
      #     def run_at
      #       30.days.from_now
      #     end
      # 
      #     def perform
      #       # charge the credit card...
      #     end
      #   end
      def re_enqueue
        self.re_enqueuable = true
      end
      
    end
    
    protected
    # clone and re-enqueue the worker.
    def enqueue_again # :nodoc:
      if self.class.re_enqueuable
        new_worker = self.clone()
        new_worker.enqueue!
      end
    end
    
  end # Worker
end # DJ