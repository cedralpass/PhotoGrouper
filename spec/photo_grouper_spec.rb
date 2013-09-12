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

  it "should take a secondary match as an option" do
    grouper = PhotoGrouper.new(Dir.home + '/Pictures/', '2013_', {:secondary_match => "good"})
    puts "folder_set.count: #{grouper.folder_set.count}"
        grouper.folder_set.count.should be > 0
        grouper.folder_set.each do |folder|
          match = folder.to_s.match 'good'
          match.to_s.should == 'good'
    end
  end

  it "should loop through a subdirectory and find images creating an image hash" do
    grouper = PhotoGrouper.new(Dir.home + '/Pictures/', '2013_', {:secondary_match => "good"})
    result = grouper.consolidate
    result.count.should > 0
    puts result.inspect
    result.each do |image|
      image.match(/JPG/i).nil?.should == false
    end
  end
end