class Node
  include Comparable
  def initialize(value)
    @value = value
    @left_child = nil
    @right_child = nil
  end
  attr_accessor :value, :left_child, :right_child

  def <=>(other)
    if value == other.value
      0
    elsif value > other.value
      1
    else
      -1
    end
  end
end
