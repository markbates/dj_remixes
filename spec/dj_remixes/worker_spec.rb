require 'spec_helper'

describe DJ::Worker do
  
  describe 'worker_class_name' do
    
    it 'should return the name of the worker' do
      w = WorkerClassNameTestWorker.new
      w.worker_class_name.should == 'worker_class_name_test_worker'
      w = WorkerClassNameTestWorker.new(:id => 1)
      w.worker_class_name.should == 'worker_class_name_test_worker/1'
    end
    
  end
  
  describe 'enqueue' do
    
    it 'should enqueue the worker' do
      w = SimpleWorker.new
      w.run_at = 1.week.from_now
      w.priority = :immediate
      job = w.enqueue!
      job.priority.should === -10000
      job.run_at.should == 1.week.from_now
      job.worker_class_name.should == w.worker_class_name
    end
    
    it 'should work on the class level' do
      SimpleWorker.run_at {Time.now}
      job = SimpleWorker.enqueue
      job.priority.should === 0
      job.run_at.should == Time.now
      job.worker_class_name.should == 'simple_worker'
    end
    
  end
  
  describe 'clone' do
  
    it 'should be set with the original args' do
      w = IHaveArgsWorker.new(1, 2, 3)
      w.a.should == 1
      w.b.should == 2
      w.c.should == 3
      w.run_at
      w.instance_variable_get('@run_at').should_not be_nil

      n = w.clone
      n.a.should == 1
      n.b.should == 2
      n.c.should == 3
      n.instance_variable_get('@run_at').should be_nil
    
      w = ILikeHashArgsWorker.new({:foo => :bar, :one => 1})
      w.options.should == {:foo => :bar, :one => 1}
      
      n = w.clone
      n.options.should == {:foo => :bar, :one => 1}
    end
  
  end
  
end
