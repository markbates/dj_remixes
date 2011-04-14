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
  
end
