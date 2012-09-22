$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "whenish/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "whenish"
  s.version     = Whenish::VERSION
  s.authors     = ["Aris Bartee"]
  s.email       = ["arisbartee@gmail.com"]
  s.homepage    = "http://github.com/arisbartee/whenish"
  s.summary     = "Rails plugin to handle english language dates"
  s.description = "Rails plugin to handle english language dates"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"

  s.add_development_dependency "sqlite3"
end
