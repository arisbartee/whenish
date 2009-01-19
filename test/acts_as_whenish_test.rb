require 'test/unit'
require 'rubygems'
gem 'activerecord', '>= 2.2.2'
require 'active_record'
 
require "#{File.dirname(__FILE__)}/../init"
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
 
 
class Person < ActiveRecord::Base
  acts_as_whenish :birth
end
class ActsAsWhenishTest < Test::Unit::TestCase
  def setup
     ActiveRecord::Schema.define(:version => 1) do
      create_table :people do |t|
        t.column :birth_month, :integer
        t.column :birth_day, :integer
        t.column :birth_year, :integer
      end
    end
  end
 
  def teardown
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
  def test_date_does_not_exist
    person = Person.new()
    assert person.no_birth_date?
    assert !person.birth_month?
    assert !person.birth_day?
    assert !person.birth_year?
  end

  def test_only_year_exist
    person = Person.new({:birth_year => 1980})
    assert !person.birth_month?
    assert !person.birth_day?
    assert person.birth_year?
    assert !person.no_birth_date?
    assert_equal 1980, person.birth_date.year
    assert_equal '??? ??, 1980', person.format_birth_date
    assert_equal 'in 1980', person.sentence_birth_date
  end  

  def test_only_month_exist
    person = Person.new({:birth_month => 3})
    assert person.birth_month?
    assert !person.birth_day?
    assert !person.birth_year?
    assert !person.no_birth_date?
    assert_equal 3, person.birth_date.month
    assert_equal 'March ??, ????', person.format_birth_date
    assert_equal 'in March', person.sentence_birth_date
  end  

  def test_only_day_exist
    person = Person.new({:birth_day => 12})
    assert !person.birth_month?
    assert person.birth_day?
    assert !person.birth_year?
    assert !person.no_birth_date?
    assert_equal 12, person.birth_date.day
    assert_equal '??? 12th, ????', person.format_birth_date
    assert_equal 'on the 12th', person.sentence_birth_date
  end

  def test_full_date
    person = Person.new({:birth_month => 3,:birth_day => 12,:birth_year => 1980})
    assert person.birth_month?
    assert person.birth_day?
    assert person.birth_year?
    assert !person.no_birth_date?
    assert_equal 3, person.birth_date.month
    assert_equal 12, person.birth_date.day
    assert_equal 1980, person.birth_date.year
    assert_equal 'March 12th, 1980', person.format_birth_date
    assert_equal 'on the 12th of March 1980', person.sentence_birth_date
  end  
end
