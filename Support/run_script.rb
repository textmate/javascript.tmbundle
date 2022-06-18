#!/usr/bin/env ruby18

require "#{ENV["TM_SUPPORT_PATH"]}/lib/tm/executor"
require "#{ENV["TM_SUPPORT_PATH"]}/lib/tm/save_current_document"
require "pathname"

TextMate.save_if_untitled

USING_NVM = ARGV[0] == '1'

if ENV.has_key?('TM_NODE') && !ENV['TM_NODE'].empty?
  NODE = ENV['TM_NODE']
else
  NODE = 'node'
end

cmd = [ NODE, ENV['TM_FILEPATH'] ]

opts = {
  :env => ENV,
  :use_hashbang => ENV.has_key?('TM_NODE'),
  :create_error_pipe => true
}

opts[:version_replace] = '\1 (NVM)' if USING_NVM

TextMate::Executor.run(cmd, opts)