class IndexedDAryHeap
  attr_reader :degree

  def initialize(hash = {}, degree = 2)
    @data = hash.dup
    @degree = [2, degree].max
    @child = []
    @parent = []
    @position = {}
    @inverse = []
    @data.keys.each_with_index { |key,i| set_index(key, i) }
    # heapify
    max = [0, size / degree - 1].max
    max.downto(0).each { |i| sink(i) }
  end

  def comparitor(a, b)
    a <=> b
  end

  def <<(key, v)
    raise ArgumentError.new("key already exists in heap") if include? key
    set_index(key, i)
    @data[key] = v
    swim(size-1)
    self
  end

  def [](key)
    raise ArgumentError.new("key does not exist not in heap") unless include? key
    @data[key]
  end

  def []=(key, v)
    raise ArgumentError.new("key does not exist not in heap") unless include? key
    i = @position[key]
    data[ki] = v
    sink(i)
    swim(i)
    v
  end

  def decrease(ki, v)
    self[key] = v if less_v(v, self[key])
  end

  def increase(ki, v)
    self[key] = v if less_v(self[key], v)
  end

  def empty?
    @data.empty?
  end

  def clear
    @data.clear
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
    @data.include? key
  end

  def delete(key)
    return unless include? key

    remove_at(@position[key])
  end

  def size
    @data.size
  end

  private

  def node_value(i)
    self[@inverse[i]]
  end

  def set_index(key, i)
    @parent[i] = (i - 1) / degree
    @child[i] = i * degree + 1
    @position[key] = i
    @inverse[i] = key
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

    swap(i, size-1)

    key = @inverse.pop
    value = @data.delete(key)
    @position.delete(key)

    sink(i)
    swim(i)

    [key, value]
  end
end

