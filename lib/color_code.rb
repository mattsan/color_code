require "color_code/version"

module ColorCode
  class Resister
    attr_reader :significant_digits
    attr_reader :multiplier
    attr_reader :tolerance

    COLORS = '黒茶赤橙黄緑青紫灰白'.freeze
    EX_COLORS = '銀金'.freeze

    def initialize(colors)
      @significant_digits = color_to_value(colors.shift)
      @significant_digits = @significant_digits * 10 + color_to_value(colors.shift)
      case colors.size
      when 1
        @multiplier = color_to_multiplier(colors.shift)
        @tolerance = 0.2
      when 2
        @multiplier = color_to_multiplier(colors.shift)
        @tolerance = color_to_tolerance(colors.shift)
      when 3..4
        @significant_digits = @significant_digits * 10 + color_to_value(colors.shift)
        @multiplier = color_to_multiplier(colors.shift)
        @tolerance = color_to_tolerance(colors.shift)
      end
    end

    def inspect
      "#{significant_digits} * 10**#{multiplier} ± #{tolerance * 100}%"
    end

    def to_s
      inspect
    end

    def to_f
      significant_digits.to_f * 10 ** multiplier
    end

    def lower_bound
      to_f * (1.0 - tolerance)
    end

    def upper_bound
      to_f * (1.0 + tolerance)
    end

    private

    def color_to_value(color)
      value = COLORS.index(color)
      value or raise "#{color} IS NOT COLOR"
    end

    def color_to_multiplier(color)
      multiplier = COLORS.index(color)
      multiplier ||= EX_COLORS.index(color) - 2
      multiplier or raise "#{color} IS NOT COLOR"
    end

    def color_to_tolerance(color)
      case color
      when '茶' then 0.01
      when '赤' then 0.02
      when '緑' then 0.005
      when '青' then 0.0025
      when '紫' then 0.001
      when '金' then 0.05
      when '銀' then 0.1
      else      raise "#{color} IS NOT COLOR"
      end
    end
  end
end

class String
  def to_resister
    colors = chars
    raise 'INVALID COLOR CODE LENGTH' unless colors.size.between?(3, 6)
    ColorCode::Resister.new(colors)
  end
end
