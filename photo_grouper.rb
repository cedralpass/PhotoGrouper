class PhotoGrouper
  attr_accessor :folder_set, :parent_path

  def initialize(parent_path, regex_match)
    @parent_path = parent_path
    dir = Dir.new(@parent_path)
    @folder_set = Set.new
    dir.each do |x|
      if x.match(regex_match) && Dir.exist?(x)
        @folder_set << x
      end
    end
    dir.close
  end
end