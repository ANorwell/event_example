task :setup do
  require 'bundler/setup'
  lib = File.expand_path('../lib', __FILE__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
  Bundler.require(:default, :development)
end

task :console => [:setup] do
  require 'pry'
  require 'event_example'
  binding.pry(quiet: true)
end
