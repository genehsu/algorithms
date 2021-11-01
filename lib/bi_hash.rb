require 'delegate'

class BiHash < DelegateClass(Hash)
  def initialize(hash = {})
    @data = hash.dup
    @inverse = {}
    index_values
    super(@data)
  end

  def []=(k, v)
    super.tap { @inverse[v] = k unless @inverse.key? v }
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

  def delete(k)
    if key? k
      v = self[k]
      @inverse.delete(v) if @inverse[v] == k
    end
    super
  end

  def delete_if
    super.tap { index_values }
  end

  def ==(object)
    BiHash === object &&
      @data == object.instance_variable_get(:@data) &&
      @inverse == object.instance_variable_get(:@inverse)
  end
  alias_method :eql?, :==

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
    super.tap { |k,v| @inverse.delete(v) if @inverse[v] == k }
  end

  def slice(*keys)
    BiHash.new(super)
  end

  def has_value?(v)
    @inverse.key?(v)
  end

  def inspect
    [
      "#<#{self.class} ",
      instance_variables
        .reject { |v| v == :@delegate_dc_obj }
        .map { |v| nv = v.to_s.sub!(/^@/, ''); "#{nv}=#{instance_variable_get(v)}" }
        .join(', '),
      ">"
    ].join("")
  end

  protected

  def index_values
    @inverse = @data.invert
  end

end
