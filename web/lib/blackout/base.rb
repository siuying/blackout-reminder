require 'tempfile'
require 'nokogiri'
require 'spreadsheet'
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
      Spreadsheet.client_encoding = 'UTF-8'
      file          = Tempfile.new('blackout')
      time_data     = Blackout::Utils.blackout_time
  
      begin
        File.open(file.path, 'w') {|f| f.write(open(url).read) }
        wb = Spreadsheet.open(file.path)
        sheet1 = wb.worksheet(0)
        
        data = []
        for idx in (0..(sheet1.row_count-1)) do
          row = sheet1.row(idx)
          unless row.hidden
            row_data = row.to_a
            if row_data.size >= 4 && row_data[0] && row_data[1] && row_data[2] && row_data[3]
              data << row_data
            end
          end
        end
        
        # format the data to db format
        uploads = {}

        data.each do |d|
          begin
            id = "#{d[0]}-#{d[1]}-#{d[2]}"
            time = Array.new(time_data[d[3].to_i.to_s.to_sym])

            if uploads[id]
              uploads[id][:time] = uploads[id][:time].concat(time).uniq
            else
              type = "blackout"
              prefecture = d[0].strip
              city = d[1].strip
              street = d[2].strip

              uploads[id] = {
                :"_id" => id,
                :type => type,
                :prefecture => prefecture,
                :city => city,
                :street => street,
                :time => time
              }
            end
          rescue StandardError => e
            puts "ERORR #{d.inspect} => #{e}"
          end
        end

        return uploads.values
      ensure
        file.close
        file.unlink
      end
    end

  end
end