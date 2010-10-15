module DJ
  class Worker
    
    def before(job)
      self.dj_object = job
      job.touch(:started_at)
    end
    
    def after(job)
    end
    
    def success(job)
      job.touch(:finished_at)
      self.enqueue_again if self.respond_to?(:enqueue_again)
    end
    
    def error(job, error)
      job.update_attributes(:started_at => nil)
    end
    
  end # Worker
end # DJ