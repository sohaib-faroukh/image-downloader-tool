require 'dotenv/load'

task :default => :download_images

task :download_images do |_task, args|
  require './application'
  command_arguments = ARGV&.dup&.drop(1) || []
  Application.start(:args => command_arguments)
end
