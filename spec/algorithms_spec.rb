# frozen_string_literal: true

class AlgorithmsTestImplementionClass
  include DataStructures
end

DATA_STRUCTURES_CLASSES = %w[
  BiHash
  BinaryHeap
].freeze

RSpec.describe Algorithms do
  it "has a version number" do
    expect(Algorithms::VERSION).not_to be nil
  end

  it "loads the data structure module" do
    expect { DataStructures }.not_to raise_error
  end

  DATA_STRUCTURES_CLASSES.each do |klass|
    it "loads the #{klass} class" do
      expect { Object.const_get "DataStructures::#{klass}" }.not_to raise_error
    end
  end

  context "when DataStructures is included" do
    DATA_STRUCTURES_CLASSES.each do |klass|
      context klass do
        it "doesn't require the module specification" do
          expect { Object.const_get "AlgorithmsTestImplementionClass::#{klass}" }.not_to raise_error
        end
      end
    end
  end
end
