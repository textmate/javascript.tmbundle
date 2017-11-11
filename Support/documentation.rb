require 'yaml'
require 'pp'

require "#{ENV['TM_SUPPORT_PATH']}/lib/exit_codes"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"

module Documentation
  HOST = "https://developer.mozilla.org/en-US/docs/Web"
  YAML_PATH = "#{ENV['TM_BUNDLE_SUPPORT']}/index.yaml"
  
  SEARCH_URL = 'https://developer.mozilla.org/en-US/search?topic=apps&topic=html&topic=css&topic=js&topic=api&topic=canvas&topic=svg&topic=webgl&topic=mobile&topic=webdev&topic=http&topic=webext&q='
  
  class << self
    
    def search_and_exit(token)
      url = "#{SEARCH_URL}#{token}"
      TextMate::exit_show_html(
        "<meta http-equiv='Refresh' content='0;URL=#{url}'>"
      )
    end
  
    def show_url_and_exit(url)
      url = "#{HOST}#{url}"
      TextMate::exit_show_html(
        "<meta http-equiv='Refresh' content='0;URL=#{url}'>"
      )
    end

    def reference(token)
      @yaml ||= YAML::load( File.read(YAML_PATH) )
      @yaml[token]
    end
    
    def open_page_for(token)
      items = reference(token) || []
      
      # If there are no matches, we just load a search results page for the
      # token.
      if items.size == 0
        search_and_exit(token)
      end
      
      # Usually there will be only one option, so we can jump straight to it.
      if items.size == 1
        show_url_and_exit(items[0][:url])
      end

      # We have more than one possible match (e.g., `indexOf` or `slice`).
      # Ask the user to pick one.
      index = {}
      choices = items.map do |item|
        index[ item[:name] ] = item[:url]
        item[:name]
      end

      choice = TextMate::UI.request_item(
        :items => choices,
        :title => 'Choose an Option'
      )
      
      # Did the user hit Cancel?
      TextMate::exit_discard if choice.nil?

      show_url_and_exit(index[choice])
    end
  end
end