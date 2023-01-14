module Marten
  module Template
    module Filter
      # The `join` filter.
      #
      # The `linebreaks` filter allows to convert a string replacing all newlines with HTML line breaks (<br />).
      class Join < Base
        def apply(value : Value, arg : Value? = nil) : Value
          raise Errors::InvalidSyntax.new("The 'join' filter requires one argument") if arg.nil?
          # raise Errors::InvalidSyntax.new("The 'join' filter requires one argument") unless arg.is_a?(String)

          # joined object must be an array
          # arg must exist and must be a string or char

          new_arg = ", "

          # Value.from(value.to_a.join(new_arg))
          Value.from("Chris")
          puts arg.raw.to_s
          Value.from(arg.raw)
        end
      end
    end
  end
end
