require 'active_record'
ActiveRecord::Base.logger = Logger.new('/tmp/dj.log')
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => '/tmp/jobs.sqlite')
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.default_timezone = :utc

ActiveRecord::Schema.define do

  create_table :delayed_jobs, :force => true do |table|
    table.integer  :priority, :default => 0
    table.integer  :attempts, :default => 0
    table.text     :handler
    table.string   :last_error
    table.datetime :run_at
    table.datetime :locked_at
    table.string   :locked_by
    table.datetime :failed_at
    table.timestamps
    table.datetime :deleted_at
    table.string   :worker_class_name
    table.datetime :started_at
    table.datetime :finished_at
  end
  
  create_table :videos, :force => true do |t|
    t.string :title
    t.text :description
    t.string :file_name
    t.boolean :encoded, :default => false
    t.timestamps
  end

end