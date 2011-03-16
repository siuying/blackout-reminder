require 'nokogiri'
require 'open-uri'

module Blackout
  class Utils
    BASE_URL = "http://www.tepco.co.jp/index-j.html"

    # return Blackout excel file url
    def self.file_urls    
      doc = Nokogiri::HTML(open(BASE_URL))
      doc.css('#urgency a').select {|link| link["href"] =~ /.+\.xls/ }.collect{|link| "http://www.tepco.co.jp" + link["href"].strip }
    end
  end
end