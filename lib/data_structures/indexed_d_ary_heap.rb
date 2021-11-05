# frozen_string_literal: true

require_relative "bi_hash"

# rubocop:disable Naming/MethodParameterName
module DataStructures
  # Sample implementation for an Indexed D-ary heap in ruby
  # In general setting degree = Edges/Nodes is the best degree
  # to balance removals vs decrease key operations
  class IndexedDAryHeap # rubocop:disable Metrics/ClassLength
    attr_reader :degree

    def initialize(hash = {}, degree = 2) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      size = hash.size
      @degree = degree
      @parent = Array.new(size)
      @child = Array.new(size)
      @ki_map = BiHash.new
      @values = Array.new(size)
      @position = Array.new(size)
      @inverse = Array.new(size)
      hash.each_with_index.each do |(k, v), i|
        @ki_map[k] = i
        @values[i] = v
        set_index(i, i)
      end
      heapify
    end

    def comparitor(a, b)
      a <=> b
    end

    def <<(pair)
      key, v = pair
      raise ArgumentError, "key already exists in heap" if include? key

      hash_size = size
      ki = @inverse[hash_size] || hash_size
      i = hash_size
      @ki_map[key] = ki
      @values[@ki_map[key]] = v
      set_index(ki, i)
      swim(hash_size)
      self
    end

    def [](key)
      raise ArgumentError, "key does not exist not in heap" unless include? key

      @values[@ki_map[key]]
    end

    def []=(key, v)
      raise ArgumentError, "key does not exist not in heap" unless include? key

      ki = @ki_map[key]
      i = @position[ki]
      @values[ki] = v
      sink(i)
      swim(i)
      @values[ki]
    end

    def decrease(key, v)
      self[key] = v if less_v(v, self[key])
    end

    def increase(key, v)
      self[key] = v if less_v(self[key], v)
    end

    def empty?
      size.zero?
    end

    def clear
      @ki_map.clear
      @values.clear
      @position.clear
      @inverse.clear
    end

    def peek
      node_value(0) unless empty?
    end

    def pop
      remove_at(0)
    end

    def include?(key)
      @ki_map.include?(key) &&
        @position[@ki_map[key]] != -1
    end

    def remove(key)
      return unless include? key

      remove_at(@position[@ki_map[key]])
    end

    def size
      @ki_map.size
    end

    private

    def heapify
      max = ((size + degree - 1) / degree) - 1
      max.downto(0).each { |i| sink(i) }
    end

    def node_value(i)
      @values[@inverse[i]]
    end

    def set_index(ki, i)
      @parent[i] = (i - 1) / degree
      @child[i] = (i * degree) + 1
      @position[ki] = i
      @inverse[i] = ki
    end

    def swap(i, j)
      @position[@inverse[j]] = i
      @position[@inverse[i]] = j
      @inverse[i], @inverse[j] = @inverse[j], @inverse[i]
    end

    def less(i, j)
      comparitor(node_value(i), node_value(j)) == -1
    end

    def less_v(v1, v2)
      comparitor(v1, v2) == -1
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
      c_end = [size, c_start + degree].min
      (c_start...c_end).each do |j|
        index = i = j if less(j, i)
      end
      index
    end

    def remove_at(i) # rubocop:disable  Metrics/MethodLength
      return if empty?

      last_index = size - 1
      swap(i, last_index)

      ki = @inverse[last_index]
      key = @ki_map.key(ki)
      @ki_map.delete(key)
      value = @values[ki]
      @values[ki] = nil
      @position[ki] = -1

      sink(i)
      swim(i)

      [key, value]
    end
  end
end
# rubocop:enable Naming/MethodParameterName
