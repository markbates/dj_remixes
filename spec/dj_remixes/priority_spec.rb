require 'spec_helper'

describe DJ::Worker do
  
  describe 'priority' do
    
    it 'should take a Symbol from the class priority list' do
      w = SimpleWorker.new
      w.priority = :medium
      w.priority.should == -500
    end
    
    it 'should return 0 if it does not recognize the priority' do
      w = SimpleWorker.new
      w.priority = :oops
      w.priority.should == 0
      
      w.priority = 'oops'
      w.priority.should == 0
      
      w.priority = false
      w.priority.should == 0
    end
    
    it 'should return value if defined' do
      w = SimpleWorker.new
      w.priority = 1000
      w.priority.should == 1000
    end
    
    it 'should return 0 as the default priority' do
      w = SimpleWorker.new
      w.priority.should == 0
    end
    
    it 'should be settable at a class level' do
      class PriorityWorkerTest < DJ::Worker
        priority :immediate
      end
      w = PriorityWorkerTest.new
      w.priority.should == -10000
    end
    
  end
  
end
