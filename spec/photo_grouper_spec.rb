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

  it "should create a destination folder if it does not exist" do
    path = '/Users/cedralpass/Pictures/test_dir'
    directory_path = PhotoGrouper.create_directory(path)
    directory_path.should == path
    Dir.exist?(path).should == true
    directory_path = PhotoGrouper.create_directory(path)
    #Clean up
    Dir.chdir path
    Dir.chdir '..'
    Dir.rmdir path
  end


  it "should copy a file to a destination folder" do
     path =  '/Users/cedralpass/Pictures/test_dir'
     grouper = PhotoGrouper.new(Dir.home + '/Pictures/', '2013_', {:secondary_match => "good"})
     result_to_consolidate = grouper.consolidate
     results = grouper.copy(path)
     result_to_consolidate.count.should == results.count
     #clean up
     Dir.chdir path
     FileUtils.rm Dir.glob('*.JPG')
     Dir.chdir '..'
     Dir.rmdir path

  end
end