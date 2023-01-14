module Marten
  module Template
    module Filter
      # The `split` filter.
      #
      # The `split` filter allows to convert a string replacing all newlines with HTML line breaks (<br />).
      class Split < Base
        def apply(value : Value, arg : Value? = nil) : Value
          raise Errors::InvalidSyntax.new("The 'split' filter requires one argument") if arg.nil?

          Value.from(value.to_s.split(arg.to_s))
        end
      end
    end
  end
end
