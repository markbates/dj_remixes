require 'spec_helper'

describe DJ::Worker do
  
  describe 're_enqueue' do
    
    it 'should re_enqueue the worker' do
      t = Time.now
      Time.stub!(:now).and_return(t)
      w = RunForeverWorker.new({:foo => :bar, :one => 1})
      w.enqueue!
      Greeter.should_receive(:greet).with("Hi from RunForeverWorker").exactly(10).times
      Delayed::Worker.new.send(:work_off, 10)
    end
    
  end
  
end
