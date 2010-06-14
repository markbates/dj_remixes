# Dir.glob(File.join(File.dirname(__FILE__), 'dj_remixes', '**/*.rb')).each do |f|
#   require File.expand_path(f)
# end
require 'delayed_job'

Delayed::Worker.guess_backend

path = File.join(File.dirname(__FILE__), 'dj_remixes')

require File.join(path, 'dj_remixes')
require File.join(path, 'worker')
require File.join(path, 'hoptoad')

if Rails.version.match(/^2/)
  require File.join(path, 'rails2', 'action_mailer')
  require File.join(path, 'rails2', 'unique_validator')
else
  require File.join(path, 'rails3', 'railtie')
  require File.join(path, 'rails3', 'unique_validator')
end