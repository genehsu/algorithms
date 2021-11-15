# frozen_string_literal: true
require 'set'

class BreadthFirstSearch
  attr_reader :start, :graph

  def initialize(start, graph)
    @start = start
    @graph = graph
  end

  def explore
    visited = Set.new
    queue = [start]

    while (node = queue.shift)
      next if visited.include? node

      visited << node

      continue = yield(node) if block_given?
      break unless continue

      queue += graph[node]
    end
  end

  def explore_path
    [].tap do |path|
      explore { |node| path << node }
    end
  end
end
