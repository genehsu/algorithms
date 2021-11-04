# frozen_string_literal: true

# rubocop:disable Naming/MethodParameterName
module DataStructures
  # Sample implementation for a binary heap in ruby
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
      swim(size - 1)
      self
    end

    def size
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
      !index_of_element(e).nil?
    end

    def remove(e)
      i = index_of_element(e)
      return unless i

      remove_at(i)
    end

    private

    def index_of_element(e)
      @data.find_index { |v| v.eql? e }
    end

    def heapify
      max = [0, (size / 2) - 1].max
      max.downto(0).each { |i| sink(i) }
    end

    def swap(i, j)
      @data[i], @data[j] = @data[j], @data[i]
    end

    def less(i, j)
      comparitor(@data[i], @data[j]) == -1
    end

    def swim(i)
      parent = (i - 1) / 2
      while i != 0 && less(i, parent)
        swap(i, parent)
        i = parent
        parent = (i - 1) / 2
      end
    end

    def sink(i)
      while (j = min_child(i)) >= 0
        swap(j, i)
        i = j
      end
    end

    def min_child(i)
      left = (2 * i) + 1
      right = (2 * i) + 2
      if left >= size
        -1
      elsif right < size && less(right, left)
        right
      elsif less(i, left)
        -1
      else
        left
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
end
# rubocop:enable Naming/MethodParameterName
