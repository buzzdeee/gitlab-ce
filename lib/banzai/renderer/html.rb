module Banzai
  module Renderer
    class HTML < CommonMarker::HtmlRenderer
      def code_block(node)
        block do
          code = node.string_content
          lang = node.fence_info

          lang_attr = lang.present? ? %Q{ lang="#{lang}"} : ''

          result =
            "<pre>" \
              "<code#{lang_attr}>#{html_escape(code)}</code>" \
            "</pre>"

          out(result)
        end
      end

      # Add support of strikethroughs (~~) and superscripts (^).
      def text(node)
        result = parse_strikethroughs(node.string_content)
        result = parse_superscripts(result)

        out(result)
      end

      private

      # Replace `~~some text~~` with `<del>some text</del>`.
      # The built-in cmark-gfm's `:strikethrough` option parses all the number of tildes
      # which breaks widely used lines like `project1~label project2~label`.
      #
      # This custom filter has been added to save the back compatibility with the `redcarpet`.
      # More details are available at https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/14835
      def parse_strikethroughs(text)
        text.gsub(/(~~.*?~~)/) { |strikethrough| "<del>#{strikethrough[2..-3]}</del>" }
      end

      # Replace `some^text` with `some<sup>text</sup>`.
      # `cmark-gfm's` does not support the `^` symbol as a superscript.
      #
      # This custom filter has been added to save the back compatibility with the `redcarpet`.
      # More details are available at https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/14835
      def parse_superscripts(text)
        text.gsub(/(?<=[^\s])(\^[^\s]+)/) { |superscript| "<sup>#{superscript[1..-1]}</sup>" }
      end
    end
  end
end
