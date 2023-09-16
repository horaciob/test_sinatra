# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV.fetch('RACK_ENV', ''))
require 'active_record'
require 'sinatra/activerecord'

loader = Zeitwerk::Loader.new

['app/models', 'app/controllers'].each do |dir|
  loader.push_dir(dir)
end

loader.setup

# set :database
