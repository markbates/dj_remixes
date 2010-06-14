require 'spec_helper'

describe HoptoadNotifier do
  
  describe "after" do
    
    it "should notify hoptoad if theres an error" do
      HoptoadNotifier.should_receive(:notify_or_ignore).with(instance_of(TypeError), instance_of(Hash))
      
      job = DJ.enqueue(WillFailJob.new)
      lambda {job.invoke_job}.should raise_error(TypeError)
    end
    
    it "should not notify hoptoad if there is no error" do
      
    end
    
  end
  
end
