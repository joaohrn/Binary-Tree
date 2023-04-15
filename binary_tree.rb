class Node
  include Comparable
  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end
  attr_accessor :data, :left_child, :right_child

  def <=>(other)
    if data == other.data
      0
    elsif data > other.data
      1
    else
      -1
    end
  end
end

class BinaryTree
  def initialize(array)
    @root = build_tree(array)
  end

  private

  def build_tree(array)
    new_array = array.sort.uniq
    return nil if new_array.empty?
    return Node.new new_array[0] if new_array.length == 1

    middle = (new_array.length / 2).round
    left = new_array[0..middle - 1]
    right = new_array[(middle + 1)..]
    root = Node.new new_array[middle]
    root.left_child = build_tree(left)
    root.right_child = build_tree(right)
    root
  end

  public

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

bbt = BinaryTree.new [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
bbt.pretty_print
