path = File.expand_path(File.dirname(__FILE__), "../lib")
$:.unshift(path) unless $:.include?(path)
require 'rubygems'
require 'lib/blackout'

describe Blackout::Utils do
  it "should return something" do
    result = Blackout::Utils.file_list
    result.should have_at_least(1).items
    result.should have(9).items
  end
end
