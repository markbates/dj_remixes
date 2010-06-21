require 'spec_helper'

describe DJ::Worker do
  
  describe 'run_at' do
    
    it 'should return a time, if specified' do
      t = 1.week.from_now
      w = SimpleWorker.new
      w.run_at = t
      w.run_at.should == t
    end
    
    it 'should return Time.now, if not specified' do
      w = SimpleWorker.new
      w.run_at.should == Time.now
    end
    
    it "should use a block to set the run at" do
      SimpleWorker.run_at {1.week.from_now}
      w = SimpleWorker.new
      w.run_at.should == 1.week.from_now
      
      w = WorkerClassNameTestWorker.new
      w.run_at.should == Time.now
    end
    
  end
  
end
