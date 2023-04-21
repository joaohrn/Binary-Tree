class Node
  include Comparable
  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end
  attr_accessor :data, :left_child, :right_child

  def to_s
    data.to_s
  end

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
  attr_accessor :root

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

  def insert(value, node = root)
    @root = Node.new(value) if root.nil?
    return node if value == node.data

    if value < node.data
      if node.left_child.nil?
        node.left_child = Node.new(value)
      else
        insert value, node.left_child
      end
    else
      if node.right_child.nil?
        node.right_child = Node.new(value)
      else
        insert value, node.right_child
      end
    end
  end

  def min_value(node = root)
    min = node
    min = min.left_child until min.left_child.nil?
    min
  end

  def delete(value, node = root)
    return nil if node.nil?

    if node.data > value
      node.left_child = delete value, node.left_child
    elsif node.data < value
      node.right_child = delete value, node.right_child
    else
      if node.left_child.nil?
        node = node.right_child
      elsif node.right_child.nil?
        node = node.left_child
      else
        node.data = min_value(node.right_child).data
        node.right_child = delete node.data, node.right_child
      end
    end
    node
  end

  def find(value, node = root)
    return node if node.nil? || node.data == value

    if value < node.data
      find value, node.left_child
    else
      find value, node.right_child
    end
  end

  def level_order(&block)
    return nil if root.nil?

    tree_array = []
    queue = []
    queue << root
    until queue.empty?
      queue << queue[0].left_child if queue[0].left_child
      queue << queue[0].right_child if queue[0].right_child
      tree_array << queue.shift
    end
    tree_array.each { |elem| block.call(elem) } if block_given?
    tree_array
  end

  def inorder(node = root, array = [], &block)
    return nil if node.nil?

    inorder(node.left_child, array)
    array << node
    inorder(node.right_child, array)

    array.each { |elem| block.call(elem) } if block_given?
    array
  end

  def preorder(node = root, array = [], &block)
    return nil if node.nil?

    array << node
    preorder(node.left_child, array)
    preorder(node.right_child, array)

    array.each { |elem| block.call(elem) } if block_given?
    array
  end

  def postorder(node = root, array = [], &block)
    return nil if node.nil?

    postorder(node.left_child, array)
    postorder(node.right_child, array)
    array << node

    array.each { |elem| block.call(elem) } if block_given?
    array
  end

  def depth(node, initial_depth = 0, guess = root)
    return initial_depth if node == guess.data
    return nil if guess.nil?

    if node < guess.data
      depth(node, initial_depth + 1, guess.left_child)
    else
      depth(node, initial_depth + 1, guess.right_child)
    end
  end

  def height(node, initial_height = 0, current = find(node))
    tree_node = current
    if tree_node.left_child.nil? && tree_node.right_child.nil?
      initial_height
    elsif tree_node.left_child.nil?
      height(node, initial_height + 1, tree_node.right_child)
    elsif tree_node.right_child.nil?
      height(node, initial_height + 1, tree_node.left_child)
    else
      [
        height(node, initial_height + 1, tree_node.left_child),
        height(node, initial_height + 1, tree_node.right_child)
      ].max
    end
  end

  def leaf?(node)
    return true if node.nil?

    if node.left_child.nil? && node.right_child.nil?
      true
    else
      false
    end
  end

  def balanced?(node = root)
    return true if leaf?(node)

    if node.right_child.nil? && height(node.data) <= 1 ||
       node.left_child.nil? && height(node.data) <= 1 ||
       node.right_child.nil? == false && node.left_child.nil? == false && (height(node.right_child.data) - height(node.left_child.data)).abs <= 1
      node_balanced = true
    else
      node_balanced = false
    end
    if node_balanced
      node_balanced = balanced?(node.left_child) && balanced?(node.right_child)
    end
    node_balanced
  end

  def rebalance
    @root = build_tree inorder
  end
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

my_tree = BinaryTree.new(Array.new(15) { rand(1..100) })
puts "Tree is balanced #{my_tree.balanced? ? 'yes' : 'no'}"

my_tree.pretty_print
puts 'Preorder'

my_tree.preorder { |elem| puts elem }

puts 'inorder'

my_tree.inorder { |elem| puts elem }

puts 'postorder'

my_tree.postorder { |elem| puts elem }

my_tree.insert 204
my_tree.insert 529
my_tree.insert 604
my_tree.insert 195
my_tree.insert 129
my_tree.insert 781
my_tree.insert 473
my_tree.insert 142
my_tree.pretty_print
puts "Tree is balanced #{my_tree.balanced? ? 'yes' : 'no'}"
my_tree.rebalance

puts "Tree is balanced #{my_tree.balanced? ? 'yes' : 'no'}"
my_tree.pretty_print
puts 'Preorder'

my_tree.preorder { |elem| puts elem }

puts 'inorder'

my_tree.inorder { |elem| puts elem }

puts 'postorder'

my_tree.postorder { |elem| puts elem }
