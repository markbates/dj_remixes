require 'spec_helper'

describe DJ::Worker do
  
  describe 'attributes' do
    
    it 'should work its method_missing magic on attributes' do
      job = SimpleWorker.new(:user => 1, 'email' => 'foo@example.com', :id => 99)
      job.attributes.should == {'user' => 1, 'email' => 'foo@example.com', 'id' => 99}
      job.id.should == 99
      job.user.should == 1
      job.email.should == 'foo@example.com'
      job.user = 2
      job.user.should == 2
      job.names = ['mark', 'bates']
      job.names.should == ['mark', 'bates']
      job.user?.should be_true
      job.foo.should be_false
      job.user = nil
      job.user?.should be_false
    end
    
  end
  
  describe 'priority' do
    
    it 'should take a Symbol from the class priority list' do
      w = SimpleWorker.new
      w.priority = :medium
      w.priority.should == 500
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
      w.priority.should == 10000
    end
    
  end
  
  describe 'run_at' do
    
    it 'should return a time, if specified' do
      t = 1.week.from_now
      w = SimpleWorker.new
      w.run_at = t
      w.run_at.should == t
    end
    
    it 'should return Time.now, if not specified' do
      now = Time.now
      Time.stub!(:now).and_return(now)
      w = SimpleWorker.new
      w.run_at.should == now
    end
    
  end
  
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
      t = 1.week.from_now
      w = SimpleWorker.new
      w.run_at = t
      w.priority = :immediate
      job = w.enqueue
      job.priority.should === 10000
      job.run_at.should == t
      job.worker_class_name.should == w.worker_class_name
    end
    
    it 'should work on the class level' do
      t = Time.now
      Time.stub!(:now).and_return(t)
      job = SimpleWorker.enqueue
      job.priority.should === 0
      job.run_at.should == t
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
  
  describe 're_enqueue' do
    
    it 'should re_enqueue the worker' do
      t = Time.now
      Time.stub!(:now).and_return(t)
      w = RunForeverWorker.new({:foo => :bar, :one => 1})
      w.enqueue
      Greeter.should_receive(:greet).with("Hi from RunForeverWorker").exactly(10).times
      Delayed::Worker.new.send(:work_off, 10)
    end
    
    it 'should re_enqueue the worker without options' do
      t = Time.now
      Time.stub!(:now).and_return(t)
      w = RunForeverWithoutOptionsWorker.new
      w.enqueue
      Greeter.should_receive(:greet).with("Hi from RunForeverWithoutOptionsWorker").exactly(10).times
      Delayed::Worker.new.send(:work_off, 10)
    end
    
  end
  
  describe 'unique?' do
    
    it 'should only allow 1 instance at a time in the queue' do
      lambda {
        OneOfAKind.enqueue
      }.should change(DJ, :count).by(1)
      
      lambda {
        job = OneOfAKind.enqueue
        job.save.should be_false
        job.errors[:base].should include("Only one one_of_a_kind can be queued at a time!")
      }.should_not change(DJ, :count)
    end
    
    it 'should let many workers in the queue if false' do
      2.times do
        lambda {
          job = DJ.new(:payload_object => ManyOfAKind.new)
          job.save!
        }.should change(DJ, :count).by(1)
      end
    end
    
  end
  
end
