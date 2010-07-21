# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dj_remixes}
  s.version = "0.0.22.20100721105250"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates"]
  s.date = %q{2010-07-21}
  s.description = %q{dj_remixes was developed by: markbates}
  s.email = %q{mark@markbates.com}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["lib/dj_remixes/action_mailer/action_mailer.rb", "lib/dj_remixes/action_mailer/action_mailer_railtie.rb", "lib/dj_remixes/active_record_railtie.rb", "lib/dj_remixes/attributes.rb", "lib/dj_remixes/callbacks.rb", "lib/dj_remixes/dj_remixes.rb", "lib/dj_remixes/hoptoad.rb", "lib/dj_remixes/priority.rb", "lib/dj_remixes/re_enqueue.rb", "lib/dj_remixes/requires.rb", "lib/dj_remixes/run_at.rb", "lib/dj_remixes/unique.rb", "lib/dj_remixes/unique_validator.rb", "lib/dj_remixes/worker.rb", "lib/dj_remixes.rb", "README", "LICENSE"]
  s.homepage = %q{http://www.metabates.com}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{magrathea}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{dj_remixes}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
