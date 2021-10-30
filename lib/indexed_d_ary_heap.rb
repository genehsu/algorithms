class IndexedDAryHeap
  attr_reader :size

  def initialize(array = [], degree = 2)
    @degree = [2, degree].max
    @values = []
    @child = []
    @parent = []
    @position = [];
    @inverse = [];
    @size = 0
    array.each_with_index { |v, i| self.<< i, v }
  end

  def comparitor(a, b)
    a <=> b
  end

  def <<(ki, v)
    raise ArgumentError.new("key index already exists in heap") if include? ki
    set_index(ki)
    @values[ki] = v
    swim(size)
    @size += 1
    self
  end

  def [](ki)
    raise ArgumentError.new("key index not in heap") unless include? ki
    @values[ki]
  end

  def []=(ki, v)
    i = @position[ki]
    values[ki] = v
    sink(i)
    swim(i)
    v
  end

  def decrease(ki, v)
    self[ki]= v if less_v(v, self[ki])
  end

  def increase(ki, v)
    self[ki]= v if less_v(self[ki], v)
  end

  def empty?
    size == 0
  end

  def clear
    @values.clear
    @position.clear
    @inverse.clear
    size = 0
  end

  def peek
    node_value(0)
  end

  def pop
    remove_at(0)
  end

  def include?(ki)
    @position[ki] != -1 && ki < @position.size
  end

  def delete(ki)
    return unless include? ki
    i = @position[ki]

    remove_at(i)
  end

  private

  def node_value(i)
    self[@inverse[i]]
  end

  def set_index(i)
    @parent[i] = (i - 1) / @degree
    @child[i] = i * @degree + 1
    @position[i] = size
    @inverse[size] = i
  end

  def swap(i, j)
    @position[@inverse[j]] = i
    @position[@inverse[i]] = j
    @inverse[i], @inverse[j] = @inverse[j], @inverse[i]
  end

  def less(i, j)
    comparitor(node_value(i), node_value(j)) < 0
  end

  def less_v(v1, v2)
    comparitor(v1, v2) < 0
  end

  def swim(i)
    while @parent[i] >= 0 && less(i, @parent[i])
      swap(i, @parent[i])
      i = @parent[i]
    end
  end

  def sink(i)
    while (j = min_child(i)) >= 0
      swap(i, j)
      i = j
    end
  end

  def min_child(i)
    index = -1
    c_start = @child[i]
    c_end = [size, c_start+@degree].min
    (c_start...c_end).each do |j|
      if less(j, i)
        index = i = j
      end
    end
    index
  end

  def remove_at(i)
    return if empty?

    ki = @inverse[i]
    @size -= 1
    swap(i, size)
    sink(i)
    swim(i)

    value, @values[ki] = @values[ki], nil

    @position[ki] = -1
    @inverse[size] = -1

    value
  end
end

