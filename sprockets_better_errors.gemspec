# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sprockets_better_errors/version'

Gem::Specification.new do |gem|
  gem.name          = "sprockets_better_errors"
  gem.version       = SprocketsBetterErrors::VERSION
  gem.authors       = ["Richard Schneeman"]
  gem.email         = ["richard.schneeman+rubygems@gmail.com"]
  gem.description   = %q{ Raise now so you don't pay later }
  gem.summary       = %q{ Better sprockets errors in development so you'll know if things work before you push to production }
  gem.homepage      = "https://github.com/schneems/sprockets_better_errors"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

msg = <<-MSG

To enable sprockets_better_errors
add this line to your `config/environments/development.rb:
  config.assets.raise_production_errors = true

MSG

  gem.post_install_message = msg

  gem.add_dependency "sprockets-rails", ">= 1.0.0"
  gem.add_dependency "actionpack", "~> 4.1"
  gem.add_dependency "activesupport", "~> 4.1"

  gem.add_development_dependency "capybara", ">= 0.4.0"
  gem.add_development_dependency "launchy", "~> 2.1.0"
  gem.add_development_dependency "poltergeist"
  gem.add_development_dependency "rake"
end
