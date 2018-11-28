# frozen_string_literal: true

module Banzai
  module Filter
    class SuggestionFilter < HTML::Pipeline::Filter
      # Class used for tagging elements that should be rendered
      TAG_CLASS = 'js-render-suggestion'.freeze

      def call
        return doc unless Suggestion.feature_enabled?

        doc.search('pre.suggestion > code').each do |node|
          node.add_class(TAG_CLASS)
        end

        doc
      end
    end
  end
end
