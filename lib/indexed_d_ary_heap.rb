require 'bi_hash'

class IndexedDAryHeap
  attr_reader :degree, :size

  def initialize(hash = {}, degree = 2)
    @degree = [2, degree].max
    @size = hash.size
    @values = Array.new(size)
    @child = Array.new(size)
    @parent = Array.new(size)
    @ki_map = BiHash.new
    @position = Array.new(size)
    @inverse = Array.new(size)
    hash.each_with_index.each do |(k, v), i|
      @ki_map[k] = i
      @values[i] = v
      set_index(i, i)
    end
    # heapify
    max = [0, size / degree - 1].max
    max.downto(0).each { |i| sink(i) }
  end

  def comparitor(a, b)
    a <=> b
  end

  def <<(key, v)
    raise ArgumentError.new("key already exists in heap") if include? key
    ki = @inverse[size] || size
    i = size
    @ki_map[key] = ki
    @values[@ki_map[key]] = v
    set_index(ki, i)
    swim(size)
    @size += 1
    self
  end

  def [](key)
    raise ArgumentError.new("key does not exist not in heap") unless include? key
    @values[@ki_map[key]]
  end

  def []=(key, v)
    raise ArgumentError.new("key does not exist not in heap") unless include? key
    ki = @ki_map[key]
    i = @position[ki]
    @values[ki] = v
    sink(i)
    swim(i)
    v
  end

  def decrease(key, v)
    self[key] = v if less_v(v, self[key])
  end

  def increase(key, v)
    self[key] = v if less_v(self[key], v)
  end

  def empty?
    size == 0
  end

  def clear
    @ki_map.clear
    @values.clear
    @position.clear
    @inverse.clear
  end

  def peek
    node_value(0)
  end

  def pop
    remove_at(0)
  end

  def include?(key)
    @ki_map.include?(key) &&
      @position[@ki_map[key]] != -1
  end

  def delete(key)
    return unless include? key

    remove_at(@position[@ki_map[key]])
  end

  private

  def node_value(i)
    @values[@inverse[i]]
  end

  def set_index(ki, i)
    @parent[i] = (i - 1) / degree
    @child[i] = i * degree + 1
    @position[ki] = i
    @inverse[i] = ki
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
    return if i <= size
    while (j = min_child(i)) >= 0
      swap(i, j)
      i = j
    end
  end

  def min_child(i)
    index = -1
    c_start = @child[i]
    c_end = [size, c_start+degree].min
    (c_start...c_end).each do |j|
      if less(j, i)
        index = i = j
      end
    end
    index
  end

  def remove_at(i)
    return if empty?

    @size -= 1
    swap(i, size)

    ki = @inverse[size]
    key = @ki_map.key(ki)
    @ki_map.delete(key)
    value, @values[ki] = @values[ki], nil
    @position[ki] = -1

    sink(i)
    swim(i)

    [key, value]
  end
end

