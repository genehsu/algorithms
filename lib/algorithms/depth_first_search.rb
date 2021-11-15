# frozen_string_literal: true
require 'set'

class DepthFirstSearch
  attr_reader :start, :graph

  def initialize(start, graph)
    @start = start
    @graph = graph
  end

  def explore
    visited = Set.new
    stack = [start]

    while (node = stack.pop)
      next if visited.include? node

      visited << node

      continue = yield(node) if block_given?
      break unless continue

      stack += graph[node]
    end
  end

  def explore_recursive
    if block_given?
      explore_r(start, Set.new) { |x| yield x }
    else
      explore_r(start, Set.new)
    end
  end

  def explore_path
    [].tap do |path|
      explore { |node| path << node }
    end
  end

  def explore_path_recursive
    [].tap do |path|
      explore_recursive { |node| path << node }
    end
  end

  def explore_r(node, visited, &block)
    return if visited.include? node
    visited << node

    continue = yield(node) if block_given?
    return unless continue

    graph[node].each do |child|
      explore_r(child, visited, &block)
    end
  end
end
