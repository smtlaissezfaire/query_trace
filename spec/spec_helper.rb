require "rubygems"
require "spec"
require "active_record"

require 'sqlite3'
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'

$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require File.dirname(__FILE__) + "/../init"

