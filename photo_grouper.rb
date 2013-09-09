class PhotoGrouper
  attr_accessor :folder_set, :parent_path, :primary_match, :secondary_match

  def initialize(parent_path, primary_match, options = {})
    @parent_path = parent_path
    @folder_set = Set.new
    @primary_match = primary_match
    @secondary_match = options[:secondary_match]

    Dir.chdir(@parent_path) do |directory|
      dir = Dir.new(directory)
      dir.each do |x|
        if x.match(@primary_match) && Dir.exist?(x)
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
        if x.match(match) && Dir.exist?(x)
          path = Dir.new(dir.path + '/' + x).path
          output_set << path
        end
      end
      dir.close
    end
    output_set
  end
end