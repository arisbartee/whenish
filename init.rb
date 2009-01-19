
require 'lib/acts_as_whenish'
ActiveRecord::Base.send(:include, HumanRecord::Acts::Whenish)
