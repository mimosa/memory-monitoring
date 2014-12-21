# coding: utf-8
require 'awesome_print' if ENV['RAILS_ENV'] || ENV['RACK_ENV'] == 'development'
require 'memory_monitoring/version'
require 'memory_monitoring/simple_formatter'
require 'memory_monitoring/injector'
require 'memory_monitoring/rack'