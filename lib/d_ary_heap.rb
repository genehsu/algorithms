class DAryHeap
  def initialize(array = [], degree = 2)
    @degree = [2, degree].max
    @data = array.dup
    @child = []
    @parent = []
    @data.each_with_index { |_, i| set_index(i) }
    heapify
  end

  def comparitor(a, b)
    a <=> b
  end

  def <<(v)
    heap_size = size
    @data << v
    set_index(heap_size)
    swim(heap_size)
    self
  end

  def size()
    @data.size
  end

  def empty?
    @data.empty?
  end

  def clear
    @data.clear
  end

  def peek
    @data[0]
  end

  def pop
    remove_at(0)
  end

  def include?(e)
    ! @data.find_index { |v| v.eql? e }.nil?
  end

  def remove(e)
    i = @data.find_index { |v| v.eql? e }
    return unless i

    remove_at(i)
  end

  private

  def set_index(i)
    @parent[i] = (i - 1) / @degree
    @child[i] = i * @degree + 1
  end

  def heapify
    binding.pry
    max = [0, size / 2 - 1].max
    max.downto(0).each { |i| sink(i) }
  end

  def swap(i, j)
    @data[i], @data[j] =@data[j], @data[i]
  end

  def less(i, j)
    comparitor(@data[i], @data[j]) < 0
  end

  def swim(k)
    while less(k, @parent[k])
      swap(k, @parent[k])
      k = @parent[k]
    end
  end

  def sink(k)
    heap_size = size
    while (j = min_child(k)) >= 0
      swap(k, j)
      k = j
    end
  end

  def min_child(i)
    index = -1
    c_start = @child[i]
    c_end = [size-1, c_start+@degree].min
    (c_start..c_end).each do |j|
      if less(j, i)
        index = i = j
      end
    end
    index
  end

  def remove_at(k)
    return if empty?

    last_index = size - 1
    value = @data[k]
    swap(k, last_index)
    @data.pop
    return value if k == last_index

    elem = @data[k]
    sink(k)
    swim(k) if @data[k].eql? elem

    value
  end
end
