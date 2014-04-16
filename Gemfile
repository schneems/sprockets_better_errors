source "https://rubygems.org"

rails_version = ENV["RAILS_VERSION"] || "default"


rails = case rails_version
when "master"
  {github: "rails/rails"}
when "default"
  ">= 4.0"
else
  "~> #{rails_version}"
end

gem "rails", rails

if rails_version.match(/^3\.2/)
  gem 'sprockets', '2.2.2.backport2'
  gem 'sprockets-rails', '2.0.0.backport1'
end

gem "sqlite3",                          :platform => [:ruby, :mswin, :mingw]
gem "activerecord-jdbcsqlite3-adapter", '>= 1.3.0.beta', :platform => :jruby

gemspec
