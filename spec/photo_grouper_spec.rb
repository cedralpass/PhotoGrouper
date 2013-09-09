require_relative "../spec/spec_helper"

describe "PhotoGrouper" do
  it "should find folders named good" do
    puts Dir.home
    puts Dir.chdir(Dir.home + '/Pictures/')
    grouper = PhotoGrouper.new(Dir.home + '/Pictures/', '2013_')
    puts "folder_set.count: #{grouper.folder_set.count}"
    grouper.folder_set.count.should be > 0
  end
end