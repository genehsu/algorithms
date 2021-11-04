# frozen_string_literal: true

RSpec.describe DataStructures::BiHash do
  subject { bi_hash }

  let(:bi_hash) { described_class.new(hash) }
  let(:hash) { {} }

  describe "#new" do
    context "without a hash" do
      let(:bi_hash) { described_class.new }

      it { is_expected.to be_an_instance_of described_class }
    end

    context "with an empty hash" do
      it { is_expected.to be_an_instance_of described_class }
    end

    context "with a hash" do
      let(:hash) { { foo: 1, bar: 2 } }

      it { is_expected.to be_an_instance_of described_class }
    end
  end

  describe "#[]" do
    subject { bi_hash[key] }

    let(:hash) { { key => :value } }
    let(:key) { :key }

    context "when the key exists" do
      it { is_expected.to eq hash[key] }
    end

    context "when the key does not exist" do
      let(:hash) { { other_key: :value } }

      it { is_expected.to be nil }

      context "with default value" do
        let(:hash) { Hash.new(default) }
        let(:default) { :an_arbitrary_value }

        it { is_expected.to eq default }
      end

      context "with a default block" do
        let(:hash) { Hash.new { |_, _| default } }
        let(:default) { :an_arbitrary_value }

        it { is_expected.to eq default }
      end
    end
  end

  describe "#[]=" do
    let(:key) { :key }
    let(:value) { :value }
    let(:new_value) { :new_value }

    before { bi_hash[key] = new_value }

    it "sets the key value pair" do
      expect(bi_hash[key]).to eq new_value
    end

    context "with an existing key value pair" do
      let(:hash) { { key => value } }

      it "updates the value at the hash key" do
        expect(bi_hash[key]).to eq new_value
      end

      it "doesn't affect the pre-existing hash" do
        expect(hash[key]).to eq value
      end
    end
  end

  describe "#==" do
    context "with two empty BiHashes" do
      let(:other) { described_class.new }

      it "is true with ==" do
        expect(bi_hash == other).to be true
      end

      it "is true with eql?" do
        expect(bi_hash.eql?(other)).to be true
      end
    end

    context "with BiHashes with data" do
      let(:other) { described_class.new(hash) }
      let(:hash) { { foo: 1, bar: 2 } }

      it "is true with ==" do
        expect(bi_hash == other).to be true
      end

      it "is true with eql?" do
        expect(bi_hash.eql?(other)).to be true
      end
    end

    context "with the source hash" do
      context "with b == h" do
        it "is false with ==" do
          expect(bi_hash == hash).to be false
        end

        it "is false with eql?" do
          expect(bi_hash.eql?(hash)).to be false
        end
      end

      context "with h == b" do
        it "is false with ==" do
          expect(hash == bi_hash).to be false
        end

        it "is false with eql?" do
          expect(hash.eql?(bi_hash)).to be false
        end
      end
    end

    context "with different key ordering of the same value" do
      let(:other) { described_class.new(other_hash) }
      let(:hash) { { foo: 1, bar: 1 } }
      let(:other_hash) { { bar: 1, foo: 1 } }

      it "is false with ==" do
        expect(bi_hash == other).to be false
      end

      it "is false with eql?" do
        expect(bi_hash.eql?(other)).to be false
      end
    end
  end

  describe "#key" do
    subject(:key_result) { bi_hash.key(value) }

    let(:hash) { { key => value } }
    let(:key) { :key }
    let(:value) { :value }

    it { is_expected.to eq key }

    context "with duplicate values" do
      let(:hash) { { foo: value, bar: 1, baz: value } }

      it "returns the first key with the value" do
        expect(key_result).to eq :foo
      end
    end
  end

  describe "#clear" do
    subject(:clear) { bi_hash.clear }

    let(:hash) { { foo: 1, bar: 2, baz: 3 } }

    it "clears the BiHash" do
      clear
      expect(bi_hash).to be_empty
      expect(bi_hash.size).to eq 0
    end

    it "doesn't affect the original hash" do
      clear
      expect(hash).not_to be_empty
      expect(hash.size).not_to eq 0
    end
  end

  describe "#delete" do
    subject(:delete) { bi_hash.delete(key) }

    let(:hash) { { foo: 1, bar: 2, baz: 3 } }
    let(:key) { hash.keys.sample }
    let(:value) { hash[key] }
    let(:expected_keys) { hash.keys - [key] }

    it "removes the key" do
      delete
      expect(bi_hash[key]).to be nil
      expect(hash.keys - bi_hash.keys).to eq [key]
    end

    it "removes the corresponding value" do
      delete
      expect(bi_hash.key(value)).to be nil
      expect(hash.values - bi_hash.values).to eq [value]
    end
  end
end
