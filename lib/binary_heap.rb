class BinaryHeap
  def initialize(array = [])
    @data = array.dup
    heapify
  end

  def comparitor(a, b)
    a <=> b
  end

  def <<(v)
    @data << v
    swim(size-1)
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

  def heapify
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
    parent = (k - 1) / 2
    while k > 0 && less(k, parent)
      swap(k, parent)
      k = parent
      parent = (k - 1) / 2
    end
  end

  def sink(k)
    heap_size = size
    while true
      left = 2 * k + 1
      right = 2 * k + 2
      smallest = left

      smallest = right if right < heap_size && less(right, left)

      break if left >= heap_size || less(k, smallest)

      swap(smallest, k)
      k = smallest
    end
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
