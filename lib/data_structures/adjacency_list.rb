# frozen_string_literal: true

class AdjacencyList
  attr_reader :data

  def initialize
    @data = Hash.new { |hash,key| hash[key] = [] }
  end

  def load(hash)
    hash.each do |k,v|
      data[k] = v
    end
  end

  def [](v)
    data[v]
  end

  def add_edge(v1, v2)
    data[v1] << v2
    data[v2] << v1
  end

  def compact
    data.each do |v, list|
      list &= list
    end
  end

  def self.from_edge_list(edges)
    adjacency_list = AdjacencyList.new
    edges.each { |v1, v2| adjacency_list.add_edge v1, v2 }
  end
end
