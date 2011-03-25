require 'tempfile'
require 'nokogiri'
require 'spreadsheet'
require 'open-uri'
require 'json'
require 'fastercsv'
$KCODE = "u"

module Blackout
  class Utils
    BASE_TEPCO_URL = "http://www.tepco.co.jp/index-j.html"

    # iterate through all the excel links, download excel file and extract data
    def self.tepco_data
      result = []

      FasterCSV.foreach("config/groups.csv") do |row|
        group, prefecture, all_cities = row
        type = "blackout"
        if group && prefecture && all_cities
          all_cities.split("、").each do |city|
            result << {
              :"_id" => "#{prefecture.strip}-#{city.strip}",
              :type => type,
              :prefecture => prefecture.tr(" ", ""),
              :city => city.tr(" ", ""),
              :group => [group],
              :company => "tepco"
            }
          end
        end
      end

      return result
    end

    def self.blackout_time
      time = JSON(open("config/time.json").read)
      
      result = []
      time.each do |company, date_data|
        date_data.each do |date, group_data|
          group_data.each do |group, time|
            result << {
              :"_id" => "#{company}-#{group}-#{date}",
              :type => "schedule",
              :company => company,
              :date => date,
              :group => group,
              :time => time
            }
          end
        end
      end

      result
    end

    # return Blackout excel file url
    def self.file_urls    
      doc = Nokogiri::HTML(open(BASE_TEPCO_URL))
      doc.css('#urgency a').select {|link| link["href"] =~ /.+\.xls/ }.collect{|link| "http://www.tepco.co.jp" + link["href"].strip }
    end
    
    # download and parse excel, and return only relevant records
    def self.tepco_data_from_url(url)
      Spreadsheet.client_encoding = 'UTF-8'

      file          = Tempfile.new('blackout')
  
      begin
        File.open(file.path, 'w') {|f| f.write(open(url).read) }
        wb = Spreadsheet.open(file.path)
        sheet1 = wb.worksheet(0)
        
        data = []
        for idx in (0..(sheet1.row_count-1)) do
          row = sheet1.row(idx)
          unless row.hidden
            row_data = row.to_a
            if row_data.size >= 4 && row_data[0] && row_data[1] && row_data[2] && row_data[3] && row_data[3].to_i > 0
              data << row_data
            end
          end
        end
        
        # format the data to db format
        uploads = {}

        data.each do |d|
          begin
            id = "#{d[0]}-#{d[1]}-#{d[2]}"
            group = d[3].to_i.to_s

            if uploads[id]
              uploads[id][:group] << group
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
                :group => [group],
                :company => "tepco"
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