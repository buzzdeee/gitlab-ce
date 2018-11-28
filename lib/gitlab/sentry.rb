# frozen_string_literal: true

module Gitlab
  class Sentry
    class << self
      attr_reader :sentry_enabled, :program
      attr_accessor :user_context

      def configure!(sentry_dsn:, program:)
        @sentry_enabled = sentry_dsn.present?
        @program = program

        Raven.configure do |config|
          config.dsn = dsn
          config.release = Gitlab.revision
    
          # Sanitize fields based on those sanitized from Rails.
          config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
          # Sanitize authentication headers
          config.sanitize_http_headers = %w[Authorization Private-Token]
          config.tags = { program: program }
        end if sentry_enabled
      end

      def in_context(current_user = nil)
        last_context = self.user_context

        begin
          self.user_context = {
            id: current_user.id,
            email: current_user.email,
            username: current_user.username
          } if current_user

          yield
        ensure
          self.user_context = last_context
        end
      end

      # This can be used for investigating exceptions that can be recovered from in
      # code. The exception will still be raised in development and test
      # environments.
      #
      # That way we can track down these exceptions with as much information as we
      # need to resolve them.
      #
      # Provide an issue URL for follow up.
      def handle_exception(exception, issue_url: nil, extra: {})
        report_exception(exception, issue_url: issue_url, extra: extra)

        raise exception if should_raise_for_dev?
      end

      # This should be used when you do not want to raise an exception in
      # development and test. If you need development and test to behave
      # just the same as production you can use this instead of
      # handle_exception.
      def report_exception(exception, issue_url: nil, extra: {})
        extra[:issue_url] = issue_url if issue_url

        if sentry_enabled
          Raven.capture_exception(exception, extra)
        else

        end
      end

      private

      def user_context= (value)
        @user_context = value

        if sentry_enabled
          Raven.tags_context(locale: I18n.locale)
          Raven.user_context(*value)
        end
      end

      def should_raise_for_dev?
        Rails.env.development? || Rails.env.test?
      end
    end
  end
end
