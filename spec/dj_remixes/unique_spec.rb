require 'spec_helper'

describe DJ::Worker do
  
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
