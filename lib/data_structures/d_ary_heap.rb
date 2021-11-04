# frozen_string_literal: true

# rubocop:disable Naming/MethodParameterName
module DataStructures
  # Sample implementation for a D-ary heap in ruby
  class DAryHeap
    def initialize(array = [], degree = 2)
      @degree = [2, degree].max
      @data = array.dup
      @child = []
      @parent = []
      @data.size.times { |i| calc_index(i) }
      heapify
    end

    def comparitor(a, b)
      a <=> b
    end

    def <<(v)
      heap_size = size
      @data << v
      calc_index(heap_size)
      swim(heap_size)
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

    def calc_index(i)
      @parent[i] = (i - 1) / @degree
      @child[i] = (i * @degree) + 1
    end

    def heapify
      max = (size / @degree) - 1
      max.downto(0).each { |i| sink(i) }
    end

    def swap(i, j)
      @data[i], @data[j] = @data[j], @data[i]
    end

    def less(i, j)
      comparitor(@data[i], @data[j]) == -1
    end

    def swim(i)
      while i != 0 && less(i, @parent[i])
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
      c_end = [size - 1, c_start + @degree].min
      (c_start..c_end).each do |j|
        index = i = j if less(j, i)
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
end
# rubocop:enable Naming/MethodParameterName
