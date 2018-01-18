require 'spec_helper'

describe Gitlab::Profiler do
  RSpec::Matchers.define_negated_matcher :not_change, :change

  let(:null_logger) { Logger.new('/dev/null') }
  let(:private_token) { 'private' }

  describe '.profile' do
    let(:app) { double(:app) }

    before do
      allow(ActionDispatch::Integration::Session).to receive(:new).and_return(app)
      allow(app).to receive(:get)
    end

    it 'returns a profile result' do
      expect(described_class.profile('/')).to be_an_instance_of(RubyProf::Profile)
    end

    it 'uses the custom logger given' do
      expect(described_class).to receive(:create_custom_logger)
                                   .with(null_logger, private_token: anything)
                                   .and_call_original

      described_class.profile('/', logger: null_logger)
    end

    it 'sends a POST request when data is passed' do
      post_data = '{"a":1}'

      expect(app).to receive(:post).with(anything, post_data, anything)

      described_class.profile('/', post_data: post_data)
    end

    it 'uses the private_token for auth if given' do
      expect(app).to receive(:get).with(anything, nil, 'PRIVATE-TOKEN' => private_token)

      described_class.profile('/', private_token: private_token)
    end

    it 'uses the user for auth if private_token is not set' do
      user = double(:user)
      user_token = 'user'

      allow(user).to receive_message_chain(:personal_access_tokens, :active, :pluck, :first).and_return(user_token)

      expect(app).to receive(:get).with(anything, nil, 'PRIVATE-TOKEN' => user_token)

      described_class.profile('/', user: user)
    end
  end

  describe '.create_custom_logger' do
    it 'does nothing when nil is passed' do
      expect(described_class.create_custom_logger(nil)).to be_nil
    end

    context 'the new logger' do
      let(:custom_logger) do
        described_class.create_custom_logger(null_logger, private_token: private_token)
      end

      it 'does not affect the existing logger' do
        expect(null_logger).not_to receive(:debug)
        expect(custom_logger).to receive(:debug).and_call_original

        custom_logger.debug('Foo')
      end

      it 'strips out the private token' do
        expect(custom_logger).to receive(:add) do |severity, _progname, message|
          expect(severity).to eq(Logger::DEBUG)
          expect(message).to include('public').and include(described_class::FILTERED_STRING)
          expect(message).not_to include(private_token)
        end

        custom_logger.debug("public #{private_token}")
      end

      it 'tracks model load times by model' do
        custom_logger.debug('This is not a model load')
        custom_logger.debug('User Load (1.2ms)')
        custom_logger.debug('User Load (1.3ms)')
        custom_logger.debug('Project Load (10.4ms)')

        expect(custom_logger.load_times_by_model).to eq('User' => 2.5,
                                                        'Project' => 10.4)
      end

      it 'logs the backtrace, ignoring lines as appropriate' do
        # Skip Rails's backtrace cleaning.
        allow(Rails.backtrace_cleaner).to receive(:clean, &:itself)

        expect(custom_logger).to receive(:add)
                                   .with(Logger::DEBUG,
                                         anything,
                                         a_string_matching(File.basename(__FILE__)))
                                   .twice

        expect(custom_logger).not_to receive(:add).with(Logger::DEBUG,
                                                        anything,
                                                        a_string_matching('lib/gitlab/profiler.rb'))

        # Force a part of the backtrace to be in the (ignored) profiler source
        # file.
        described_class.with_custom_logger(nil) { custom_logger.debug('Foo') }
      end
    end
  end

  describe '.with_custom_logger' do
    context 'when the logger is set' do
      it 'uses the replacement logger for the duration of the block' do
        expect(null_logger).to receive(:debug).and_call_original

        expect { described_class.with_custom_logger(null_logger) { ActiveRecord::Base.logger.debug('foo') } }
          .to not_change { ActiveRecord::Base.logger }
          .and not_change { ActionController::Base.logger }
          .and not_change { ActiveSupport::LogSubscriber.colorize_logging }
      end

      it 'returns the result of the block' do
        expect(described_class.with_custom_logger(null_logger) { 2 }).to eq(2)
      end
    end

    context 'when the logger is nil' do
      it 'returns the result of the block' do
        expect(described_class.with_custom_logger(nil) { 2 }).to eq(2)
      end

      it 'does not modify the standard Rails loggers' do
        expect { described_class.with_custom_logger(nil) { } }
          .to not_change { ActiveRecord::Base.logger }
          .and not_change { ActionController::Base.logger }
          .and not_change { ActiveSupport::LogSubscriber.colorize_logging }
      end
    end
  end

  describe '.api_request?' do
    it 'returns true if the URL contains /api/v3' do
      expect(described_class.api_request?('http://example.com/api/v3/projects')).to be_truthy
    end

    it 'returns true if the URL contains /api/v4' do
      expect(described_class.api_request?('http://example.com/api/v4/projects')).to be_truthy
    end

    it 'returns false otherwise' do
      expect(described_class.api_request?('http://example.com/api/v5/projects')).to be_falsey
    end
  end
end
