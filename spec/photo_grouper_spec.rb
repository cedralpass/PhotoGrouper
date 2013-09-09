require_relative "../spec/spec_helper"

describe "PhotoGrouper" do
  it "should find folders named good" do
    grouper = PhotoGrouper.new(Dir.home + '/Pictures/', '2013_')
    puts "folder_set.count: #{grouper.folder_set.count}"
    grouper.folder_set.count.should be > 0
    grouper.folder_set.each do |folder|
      match = folder.to_s.match '2013_'
      match.to_s.should == '2013_'
    end
  end
end