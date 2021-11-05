# frozen_string_literal: true

RSpec.describe DataStructures::IndexedDAryHeap do
  subject { heap }

  def array_to_hash(array)
    array.map { |v| [v, v] }.to_h
  end

  def it_empties_with_these_elements(hash)
    hash.sort_by(&:last).each do |k, v|
      expect(heap.pop).to eq [k, v]
    end
  end

  let(:heap) { described_class.new(hash) }
  let(:hash) { {} }

  describe "#new" do
    context "without an argument" do
      let(:heap) { described_class.new }

      it { is_expected.to be_empty }
    end

    context "with an empty argument" do
      it { is_expected.to be_empty }
    end

    context "with a hash of elements" do
      let(:hash) { array_to_hash(%i[e u a o i]) }

      it "creates a heap with those elements" do
        expect(heap.size).to eq hash.size
        expect(heap.peek).to eq :a
        it_empties_with_these_elements(hash)
      end
    end

    context "with arity" do
      let(:heap) { described_class.new(hash, arity) }
      let(:arity) { 3 }
      let(:hash) { array_to_hash(("b".."z").to_a.shuffle + ["a"]) }

      it "creates a heap with those elements" do
        expect(heap.size).to eq hash.size
        expect(heap.peek).to eq "a"
        it_empties_with_these_elements(hash)
      end
    end
  end

  describe "#<<" do
    let(:value) { "m" }
    let(:element) { [value, value] }

    context "when the heap is empty" do
      it "adds an element" do
        expect(heap.size).to eq 0
        expect(heap.peek).to eq nil
        heap << element
        expect(heap.size).to eq 1
        expect(heap.peek).to eq value
      end
    end

    context "when the heap has data" do
      context "and the element is the least" do
        let(:hash) { array_to_hash(%w[n o p q r]) }

        it "adds the element to the top of the heap" do
          heap << element
          expect(heap.size).to eq hash.size + 1
          expect(heap.peek).to eq value
        end
      end

      context "and the element is not the least" do
        let(:hash) { array_to_hash(%w[a e g l p t z]) }

        it "adds the element to the heap" do
          heap << element
          expect(heap.size).to eq hash.size + 1
          expect(heap.peek).not_to eq element
          it_empties_with_these_elements(array_to_hash(hash.keys + [value]))
        end
      end
    end
  end

  describe "#size" do
    subject { heap.size }

    context "when the heap is empty" do
      it { is_expected.to eq 0 }
    end

    context "when the heap has elements" do
      let(:hash) { array_to_hash(%w[a b c d e]) }

      it { is_expected.to eq hash.size }
    end
  end

  describe "#empty?" do
    context "with a new instance" do
      let(:heap) { described_class.new }

      it { is_expected.to be_empty }
    end

    context "with a new instance with an empty array" do
      it { is_expected.to be_empty }
    end

    context "with a non-empty heap" do
      let(:hash) { array_to_hash(%w[a b c d e]) }

      it { is_expected.not_to be_empty }
    end
  end

  describe "#clear" do
    context "when the heap is empty" do
      it "is a no-op" do
        expect(heap).to be_empty
        heap.clear
        expect(heap).to be_empty
      end
    end

    context "when the heap has elements" do
      let(:hash) { array_to_hash(%w[a b c d e]) }

      it "empties the heap" do
        expect(heap).not_to be_empty
        heap.clear
        expect(heap).to be_empty
      end

      it "does not affect the orginal hash" do
        heap.clear
        expect(heap).to be_empty
        expect(hash).not_to be_empty
      end
    end
  end

  describe "#peek" do
    subject { heap.peek }

    context "when the heap is empty" do
      it { is_expected.to eq nil }
    end

    context "when the heap has elements" do
      let(:hash) { array_to_hash(%w[e d c b a]) }

      it "returns the same element on repeated calls" do
        expect(heap.peek).to eq "a"
        expect(heap.peek).to eq "a"
      end
    end
  end

  describe "#pop" do
    subject { heap.pop }

    context "when the heap is empty" do
      it { is_expected.to eq nil }
    end

    context "when the heap has elements" do
      let(:hash) { array_to_hash(%w[e d c b a]) }

      it "returns the elements in sorted order in repeated calls" do
        it_empties_with_these_elements(hash)
        expect(heap.pop).to eq nil
      end
    end
  end

  describe "#include?" do
    subject { heap.include? value }

    let(:value) { "c" }

    context "when the element exists in the heap" do
      let(:hash) { array_to_hash(%w[a b c d e]) }

      it { is_expected.to eq true }
    end

    context "when the element does not exist in the heap" do
      let(:hash) { array_to_hash(%w[x y z p d q]) }

      it { is_expected.to eq false }
    end
  end

  describe "#remove" do
    subject(:remove) { heap.remove value }

    let(:value) { "c" }

    context "when the element exists in the heap" do
      let(:hash) { array_to_hash(%w[a b c d e]) }

      it { is_expected.to eq [value, value] }

      it "changes the size of the heap" do
        expect { remove }.to change(heap, :size).by(-1)
      end
    end

    context "when the element does not exist in the heap" do
      let(:hash) { array_to_hash(%w[x y z p d q]) }

      it { is_expected.to eq nil }
    end
  end
end
