# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      module External
        module File
          class NotSupported < Base
            def content
              nil
            end
          end
        end
      end
    end
  end
end
