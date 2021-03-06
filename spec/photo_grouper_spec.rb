require_relative "../spec/spec_helper"

describe "PhotoGrouper" do

  before(:all) do
    @path = Dir.pwd
  end

  before(:each) do
    Dir.chdir @path
  end

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
    directory_path.should == path
    #Clean up
    Dir.chdir path
    Dir.chdir '..'
    Dir.rmdir path
  end


  it "should copy a file to a destination folder" do
    path = '/Users/cedralpass/Pictures/test_dir'
    grouper = PhotoGrouper.new(Dir.home + '/Pictures/', '2013_', {:secondary_match => "good"})
    result_to_consolidate = grouper.consolidate
    results = grouper.copy(path)
    results.count.should == result_to_consolidate.count
    #clean up
    Dir.chdir path
    FileUtils.rm Dir.glob('*.JPG')
    Dir.chdir '..'
    Dir.rmdir path
    Dir.exist?(path).should == false

  end

  it "should extract a file name" do
    path = "/Users/cedralpass/Pictures/2013_09_02/good/IMG_6034.JPG"
    file_name = PhotoGrouper.extract_file_name path
    file_name.should == 'IMG_6034.JPG'
  end

  it "should namespace an image by its date from exif" do
    namespaced_name = PhotoGrouper.namespace('IMG_5165.JPG')
    namespaced_name.should == '2013_02_09_IMG_5165.JPG'
  end


end