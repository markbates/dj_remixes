module Mail
  class Message
    
    class MailmanWorker < DJ::Worker
      priority :urgent
      run_at {1.year.ago}
      
      def perform
        message = Marshal.load(self.mail)
        message.deliver_without_worker
      end
    end # MailmanWorker
    
    def deliver_with_worker
      if ActionMailer::Base.delivery_method == :test
        deliver_without_worker
      else
        Mail::Message::MailmanWorker.enqueue(:mail => Marshal.dump(self))
        return self
      end
    end
    
    alias_method_chain :deliver, :worker
    
  end # Message
end # Mail