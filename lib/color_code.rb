require "color_code/version"

module ColorCode
  class Resister
  end
end

class String
  def to_resister
    colors = chars
    raise 'invalid length' unless color.size.between?(3, 6)
    ColorCode::Resister.new(*colors)
  end
end
