# frozen_string_literal: true

require "delegate"

module DataStructures
  # This class is a specialization of Hash
  # that delegates most operations to an internal Hash
  # and keeps an inverse value hash for the inverse lookup
  class BiHash < DelegateClass(Hash)
    def initialize(hash = {})
      @data = hash.dup
      @inverse = {}
      index_values
      super(@data)
    end

    def []=(key, value)
      super.tap { @inverse[value] = key unless @inverse.key? value }
    end

    def clear
      super.tap { index_values }
    end

    def compact
      BiHash.new(super)
    end

    def compact!
      super.tap { @inverse.delete(nil) }
    end

    def delete(key)
      if key? key
        v = self[key]
        @inverse.delete(v) if @inverse[v] == key
      end
      super
    end

    def delete_if
      super.tap { index_values }
    end

    def ==(other)
      other.is_a?(BiHash) &&
        @data == other.instance_variable_get(:@data) &&
        @inverse == other.instance_variable_get(:@inverse)
    end
    alias eql? ==

    def except(*keys)
      BiHash.new(super)
    end

    def key(value)
      @inverse[value]
    end

    def merge(*other_hashes)
      BiHash.new(super)
    end

    def merge!(*other_hashes)
      super.tap { index_values }
    end

    def reject
      BiHash.new(super)
    end

    def reject!
      super.tap { index_values }
    end

    def replace(other_hash)
      super.tap { index_values }
    end

    def select
      BiHash.new(super)
    end

    def select!
      super.tap { index_values }
    end

    def shift
      super.tap { |k, v| @inverse.delete(v) if @inverse[v] == k }
    end

    def slice(*keys)
      BiHash.new(super)
    end

    def value?(value)
      @inverse.key?(value)
    end
    alias has_value? value?

    def inspect
      ["#<#{self.class} ",
       instance_variables
         .reject { |v| v == :@delegate_dc_obj }
         .map do |v|
         nv = v.to_s.sub!(/^@/, "")
         "#{nv}=#{instance_variable_get(v)}"
       end.join(", "),
       ">"].join
    end

    protected

    def index_values
      @inverse = @data.each_with_object({}) { |(k, v), hash| hash[v] = k unless hash.key? v }
    end
  end
end
