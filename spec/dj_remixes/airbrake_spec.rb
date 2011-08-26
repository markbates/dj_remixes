require 'spec_helper'

describe Airbrake do
  
  describe "after" do
    
    it "should notify airbrake if theres an error" do
      Airbrake.should_receive(:notify_or_ignore).with(instance_of(TypeError), instance_of(Hash))
      
      job = DJ.enqueue(WillFailJob.new)
      lambda {job.invoke_job}.should raise_error(TypeError)
    end
    
    it "should not notify airbrake if there is no error" do
      
    end
    
  end
  
end
