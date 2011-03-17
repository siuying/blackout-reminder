path = File.expand_path(File.dirname(__FILE__), "../lib")
$:.unshift(path) unless $:.include?(path)
require 'rubygems'
require 'lib/blackout'

describe Blackout::Utils do
  it "should return something" do
    result = Blackout::Utils.file_urls
    result.should have_at_least(1).items
    result.should have(9).items
  end
  
  it "should provide time data" do
    result = Blackout::Utils.blackout_time
    result[:"1"].should have(2).items
  end
end
