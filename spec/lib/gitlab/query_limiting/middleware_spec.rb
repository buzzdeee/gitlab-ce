require 'spec_helper'

describe Gitlab::QueryLimiting::Middleware do
  describe '#call' do
    it 'runs the application with query limiting in place' do
      middleware = described_class.new(-> (env) { env })

      expect_any_instance_of(Gitlab::QueryLimiting::Transaction)
        .to receive(:act_upon_results)

      expect(middleware.call({ number: 10 }))
        .to eq({ number: 10 })
    end
  end
end
