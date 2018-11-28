require 'fast_spec_helper'

# frozen_string_literal: true

describe Gitlab::CorrelationId do
  describe '.use_id' do
    it 'yields when executed' do
      expect { |blk| described_class.use_id('id', &blk) }.to yield_control
    end

    it 'stacks correlation ids' do
      described_class.use_id('id1') do
        described_class.use_id('id2') do |last_id|
          expect(last_id).to eq('id2')
        end
      end
    end

    it 'for missing correlation id it preserves last one' do
      described_class.use_id('id1') do
        described_class.use_id(nil) do |last_id|
          expect(last_id).to eq('id1')
        end
      end
    end
  end

  describe '.last_id' do
    it 'returns last correlation id' do
      described_class.use_id('id1') do
        described_class.use_id('id2') do
          expect(described_class.last_id).to eq('id2')
        end
      end
    end
  end

  describe '.ids' do
    it 'returns empty list if not correlation is used' do
      expect(described_class.ids).to be_empty
    end

    it 'returns list if correlation ids are used' do
      described_class.use_id('id1') do
        described_class.use_id('id2') do
          expect(described_class.ids).to eq(['id1', 'id2'])
        end
      end
    end
  end
end
