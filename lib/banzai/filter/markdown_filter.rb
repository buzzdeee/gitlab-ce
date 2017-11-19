module Banzai
  module Filter
    class MarkdownFilter < HTML::Pipeline::TextFilter
      # The `:strikethrough` option is disabled intentionally.
      # The `cmark-gfm` parses any number of tildes (~) as a strikethrough
      # which breaks strings like `gitlab-ce~bug gitlab-ce~regression`.
      # We need to support only double tildes (~~) as a strikethrough.
      # The support of strikethroughs is placed in lib/banzai/renderer/html.rb
      COMMONMARK_OPTIONS = [:autolink, :table, :tagfilter].freeze

      def initialize(text, context = nil, result = nil)
        super(text, context, result)
        @text = @text.delete("\r")
      end

      def call
        self.class.renderer.call(@text).rstrip
      end

      def self.renderer
        Thread.current[:banzai_markdown_renderer] ||= begin
          proc do |content|
            # In case we no longer need any overridden methods in lib/banzai/renderer/html.rb
            # the rendering calls below could be refactored as just one line:
            # `CommonMarker.render_html(content, :FOOTNOTES, COMMONMARK_OPTIONS)`

            doc = CommonMarker.render_doc(content, :FOOTNOTES, COMMONMARK_OPTIONS)
            Banzai::Renderer::HTML.new.render(doc)
          end
        end
      end
    end
  end
end
