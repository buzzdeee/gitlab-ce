require 'spec_helper'

describe Gitlab::QueryLimiting do
  describe '.enable?' do
    it 'returns true in a test environment' do
      expect(described_class.enable?).to eq(true)
    end

    it 'returns true in a development environment' do
      allow(Rails.env).to receive(:development?).and_return(true)

      expect(described_class.enable?).to eq(true)
    end

    it 'returns true on GitLab.com' do
      allow(Gitlab).to receive(:com?).and_return(true)

      expect(described_class.enable?).to eq(true)
    end

    it 'returns true in a non GitLab.com' do
      expect(Gitlab).to receive(:com?).and_return(false)
      expect(Rails.env).to receive(:development?).and_return(false)
      expect(Rails.env).to receive(:test?).and_return(false)

      expect(described_class.enable?).to eq(false)
    end
  end
end
