require 'exifr'

class PhotoGrouper

  attr_accessor :folder_set, :parent_path, :primary_match, :secondary_match, :image_set

  def initialize(parent_path, primary_match, options = {})
    @parent_path = parent_path
    @folder_set = Set.new
    @primary_match = primary_match
    @secondary_match = options[:secondary_match]

    Dir.chdir(@parent_path) do |directory|
      dir = Dir.new(directory)
      dir.each do |x|
        if x.match(/#{@primary_match}/i) && Dir.exist?(x)
          if @secondary_match
            @folder_set.merge find_matching_paths(dir.path + x, secondary_match, folder_set)
          else
            @folder_set << x
          end
        end
      end
      dir.close
    end
  end

  def find_matching_paths(path, match, output_set)
    Dir.chdir(path) do |directory|
      dir = Dir.new(directory)
      dir.each do |x|
        if x.match(/#{match}/i) && Dir.exist?(x)
          path = Dir.new(dir.path + '/' + x).path
          output_set << path
        end
      end
      dir.close
    end
    output_set
  end

  def consolidate
    @image_set = Set.new
    @folder_set.each do |folder|
      dir = Dir.new(folder)

      dir.each do |sub_folder|
        if sub_folder.match(/JPG/i) && !Dir.exist?(sub_folder)
          @image_set << folder + '/' + sub_folder if File.file?(folder + '/' + sub_folder)

        end
      end
    end
    @image_set
  end

  def self.create_directory(path)
    FileUtils.mkdir(path) unless Dir.exist?(path)
    Dir.new(path).to_path
  end

  def copy(path)
    result_set = Set.new
    PhotoGrouper.create_directory(path)
    if @image_set.count > 0
      @image_set.each do |image|
        copy = FileUtils.cp(image, path)
        result_set << image
      end
    end
    result_set
  end
end