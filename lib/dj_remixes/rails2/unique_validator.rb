Delayed::Worker.backend.send(:class_eval) do
  def validate_with_unique
    validate_without_unique
    if self.payload_object.respond_to?(:unique?) && self.new_record?
      if self.payload_object.unique?
        if DJ.count(:all, :conditions => {:worker_class_name => self.payload_object.worker_class_name, :finished_at => nil}) > 0
          self.errors.add_to_base("Only one #{self.payload_object.worker_class_name} can be queued at a time!")
        end
      end
    end
  end
  
  alias_method_chain :validate, :unique
end