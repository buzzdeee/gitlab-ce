require 'capybara/dsl'

module QA
  module Factory
    class Product
      include Capybara::DSL
      attr_reader :factory

      Attribute = Struct.new(:name, :block)

      def initialize(factory)
        @factory  = factory
        @location = current_url
      end

      def visit!
        visit @location
      end

      def self.populate!(factory)
        new(factory).tap do |product|
          factory.class.attributes.each_value do |attribute|
            product.instance_exec(&attribute.block).tap do |value|
              product.define_singleton_method(attribute.name) { value }
            end
          end
        end
      end
    end
  end
end
