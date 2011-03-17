require 'tempfile'
require 'nokogiri'
require 'parseexcel'
require 'open-uri'

module Blackout
  class Utils
    BASE_URL = "http://www.tepco.co.jp/index-j.html"

    # iterate through all the excel links, download excel file and extract data
    def self.blackout_data
      result = []
      file_urls.each do |url| 
        result.concat(blackout_data_from_url(url))
      end
      return result
    end
    
    def self.blackout_time
      {
        :"1" => [["09:20", "13:00"], ["16:50", "20:30"]],
        :"2" => [["12:20", "16:00"]],
        :"3" => [["15:20", "19:00"]],
        :"4" => [["18:20", "22:00"]],
        :"5" => [["06:20", "10:00"], ["13:50", "17:30"]]
      }
    end

    # return Blackout excel file url
    def self.file_urls    
      doc = Nokogiri::HTML(open(BASE_URL))
      doc.css('#urgency a').select {|link| link["href"] =~ /.+\.xls/ }.collect{|link| "http://www.tepco.co.jp" + link["href"].strip }
    end
    
    # download and parse excel, and return only relevant records
    def self.blackout_data_from_url(url)
      file = Tempfile.new('blackout')
      
      begin
        File.open(file.path, 'w') {|f| f.write(open(url).read) }
        wb = Spreadsheet::ParseExcel.parse(file.path)
        rows = wb.worksheet(0).map() {|r| r unless r.nil?}.compact
        data = rows.map() { |r| r.map() { |c| c.to_s('UTF-8') unless c.nil? }.compact rescue nil }
        return data.select { |item| item.class == Array && item.length == 4 && item[3].to_i > 0 }
      ensure
        file.close
        file.unlink
      end
    end

  end
end