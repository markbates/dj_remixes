require 'spec_helper'

describe ActionMailer do
  
  it 'should create a worker for an ActionMailer class' do
    pending
    Object.const_defined?('PostmanWorker').should be_false
    require File.join(File.dirname(__FILE__), '..', '..', 'support', 'postman')
    Object.const_defined?('PostmanWorker').should be_true
    post = mock('Postman')
    post.should_receive(:deliver!)
    Postman.should_receive(:new).with('welcome_email', 1, 'hello!').and_return(post)
    job = Postman.deliver_welcome_email(1, 'hello!')
    job.invoke_job
  end
  
end
