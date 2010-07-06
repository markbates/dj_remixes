module DJ
  
  class << self
    
    # Pass off calls to the backend:
    def method_missing(sym, *args, &block)
      Delayed::Worker.backend.send(sym, *args, &block)
    end
    
  end
  
end

Delayed::Worker.backend.send(:class_eval) do
  def invoke_job_with_callbacks
    payload_object.before(self) if payload_object.respond_to?(:before)
    begin
      invoke_job_without_callbacks
      payload_object.success(self) if payload_object.respond_to?(:success)
    rescue Exception => e
      payload_object.failure(self, e) if payload_object.respond_to?(:failure)
      raise e
    ensure
      payload_object.after(self) if payload_object.respond_to?(:after)
    end
  end
  alias_method_chain :invoke_job, :callbacks
end