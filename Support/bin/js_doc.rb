#!/usr/bin/env ruby -w
# encoding: utf-8

# Index from: https://developer.mozilla.org/Special:Sitemap
# curl -s https://developer.mozilla.org/Special:Sitemap | perl -0ne 'print "$1\t$2\n" while (/a rel="internal" href="https:\/\/developer.mozilla.org\/en\/JavaScript\/Reference\/Global_Objects\/(.*?)"[^>]*>(.*?)<\/a>/igs)' | sort > mdc_index.txt
# curl -s https://developer.mozilla.org/Special:Sitemap | perl -0ne 'print "$1\t$2\n" while (/a rel="internal" href="https:\/\/developer.mozilla.org\/en\/DOM\/(.*?)"[^>]*>(.*?)<\/a>/igs)' | sort > mdc_dom_index.txt

require "exit_codes"
require "ui"
require "web_preview"

MDC_INDEX = ENV['TM_BUNDLE_SUPPORT'] + '/data/mdc_index.txt'

term = STDIN.read.strip
results = []

def show_doc document
  puts "<meta http-equiv=\"refresh\" content=\"0; https://developer.mozilla.org/en/#{document}\">"
  TextMate.exit_show_html
end

File.open(MDC_INDEX).each do |line|
  fields = line.split(/\t/)

	if fields[1][/#{term}/i]
	  results.push fields[0]
	end
end

if results.length == 0
  TextMate.exit_show_tool_tip("No results for #{term} found")
elsif results.length == 1
  show_doc(results[0])
else
  ui_results = results.dup
  ui_results.length.times do |i|
    ui_results[i] = ui_results[i].gsub("JavaScript/Reference/Global_Objects/", "")
    ui_results[i] = ui_results[i].gsub("DOM/", "")
  end
  choice = TextMate::UI.menu(ui_results)
  exit if choice.nil?
  show_doc(results[choice])
end
