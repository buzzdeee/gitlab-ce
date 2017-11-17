module Rouge
  module Plugins
    module CommonMarker
      def code_block(code, language)
        lexer = Lexer.find_fancy(language, code) || Lexers::PlainText

        formatter = rouge_formatter(lexer)
        formatter.format(lexer.lex(code))
      end

      # override this method for custom formatting behavior
      def rouge_formatter(lexer)
        Formatters::HTMLLegacy.new(css_class: "highlight #{lexer.tag}")
      end
    end
  end
end
