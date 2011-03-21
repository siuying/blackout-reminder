require 'tempfile'
require 'nokogiri'
require 'spreadsheet'
require 'open-uri'

$KCODE = "u"

module Blackout
  class Utils
    BASE_TEPCO_URL = "http://www.tepco.co.jp/index-j.html"

    # iterate through all the excel links, download excel file and extract data
    def self.tepco_data
      result = []
      file_urls.each do |url| 
        result.concat(tepco_data_from_url(url))
      end
      return result
    end

    def self.blackout_time
      doc = Nokogiri::HTML(open(BASE_TEPCO_URL))
      number_map = {"１" => "1", "２" => "2", "３" => "3", "４" => "4", "５" => "5"}
      para = doc.css("#urgency p").select do |p|
        p.text =~ /停電時間は表中の数字（グループ）をご覧ください。/
      end.first
      puts para.inner_text

      time = {}
      para.inner_text.scan(/第([１２３４５])グループ.([0-9]+:[0-9]+).([0-9]+:[0-9]+)/) do |group, from, to|
        group_number = number_map[group]
        if !time[group_number]
          time[group_number] = []
        end
        time[group_number] << [from, to]
      end
      time
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
            time = d[3].to_i.to_s

            if uploads[id]
              uploads[id][:time] << time
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
                :time => [time],
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