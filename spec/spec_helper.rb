require 'rubygems'
require 'fileutils'
require 'logger'
require 'timecop'

FileUtils.mkdir_p(File.join(File.dirname(__FILE__), 'tmp'))
RAILS_DEFAULT_LOGGER = Logger.new(File.join(File.dirname(__FILE__), 'tmp', 'dj.log'))

gem 'activesupport'
gem 'activerecord'
require 'action_mailer'

module HoptoadNotifier
  def self.notify_or_ignore(error, options = {})
  end
end

require File.join(File.dirname(__FILE__), '..', 'delayed_job', 'lib', 'delayed_job')

Delayed::Worker.guess_backend

module Rails
  class << self
    def version
      '2.3.5'
    end
  end
end
require File.join(File.dirname(__FILE__), 'database.rb')

require 'spec'

require File.join(File.dirname(__FILE__), '..', 'lib', 'dj_remixes')
require File.join(File.dirname(__FILE__), '..', 'lib', 'dj_remixes', 'rails2', 'action_mailer')


Spec::Runner.configure do |config|
  
  config.before(:all) do
    
  end
  
  config.after(:all) do
    
  end
  
  config.before(:each) do
    Timecop.freeze(DateTime.now)
  end
  
  config.after(:each) do
    Timecop.return
    DJ.delete_all
  end
  
end

class WillFailJob < DJ::Worker
  
  def perform
    1 / nil
  end
  
end

class SimpleWorker < DJ::Worker
  
  def perform
  end
  
end

class RunForeverWorker < DJ::Worker
  re_enqueue
  
  def perform
    Greeter.greet("Hi from RunForeverWorker")
  end
  
end

class IHaveArgsWorker < DJ::Worker
  attr_accessor :a
  attr_accessor :b
  attr_accessor :c
  def initialize(a, b, c)
    self.a = a
    self.b = b
    self.c = c
  end
end

class ILikeHashArgsWorker < DJ::Worker
  attr_accessor :options
  def initialize(options)
    self.options = options
  end
end

class WorkerClassNameTestWorker < DJ::Worker
end

module Greeter
  def self.greet(msg)
    puts msg
  end
end

class OneOfAKind < DJ::Worker
  is_unique
  
  def perform
  end
end

class ManyOfAKind < DJ::Worker
  def perform
  end
end