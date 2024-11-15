# frozen_string_literal: true

class PathCollection
  def initialize(dotmatch: false, reverse: false)
    @dotmatch = dotmatch
    @reverse = reverse!
  end

  def paths
    files = if @dotmatch
              Dir.entries('.').sort
            else
              Dir.glob('*')
            end
    files.reverse! if @reverse
    files
  end
end
