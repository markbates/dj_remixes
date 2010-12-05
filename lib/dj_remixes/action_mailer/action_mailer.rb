module Mail
  class Message
    
    class MailmanWorker < DJ::Worker

      def perform   
        # Force loading of the class first to avoid the dreaded 'undefined class/module' error
        eval(self.klass)
        message = Marshal.load(self.mail)
        message.deliver_without_worker
      end
     
    end # MailmanWorker
    
    def deliver_with_worker
      if ActionMailer::Base.delivery_method == :test
        deliver_without_worker
      else
        puts self
        Mail::Message::MailmanWorker.enqueue(dj_worker_options.merge(:mail => Marshal.dump(self), :klass => self.delivery_handler.name))
        return self
      end
    end
        
    alias_method_chain :deliver, :worker
    
    def priority(stat)
      dj_worker_options[:priority] = stat
      self
    end
    
    def run_at(time)
      dj_worker_options[:run_at] = time
      self
    end
    
    private
    
    def dj_worker_options
      @_dj_worker_opts ||= {
        :run_at   => 1.year.ago,
        :priority => :urgent
      }
    end    
    
  end # Message
end # Mail