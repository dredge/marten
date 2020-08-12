module Marten
  module DB
    module Field
      abstract class Base
        @primary_key : ::Bool
        @blank : ::Bool
        @null : ::Bool
        @name : ::String?
        @db_column : ::String | Symbol | Nil

        getter id
        getter name

        def initialize(
          @id : ::String,
          @primary_key = false,
          @blank = false,
          @null = false,
          @editable = true,
          @name = nil,
          @db_column = nil
        )
        end

        abstract def from_db_result_set(result_set : ::DB::ResultSet)
        abstract def to_db(value) : ::DB::Any

        # Returns the name of the column associated with the considered field.
        def db_column
          @db_column.try(&.to_s) || @id
        end

        def primary_key?
          @primary_key
        end

        def blank?
          @blank
        end

        def null?
          @null
        end

        # Runs pre-save logic for the specific field and record at hand.
        #
        # This method does nothing by default but can be overridden for specific fields that need to set values on the
        # model instance before save or perform any pre-save logic.
        def prepare_save(record, new_record = false)
        end

        # Runs custom validation logic for a specific model field and model object.
        #
        # This method should be overriden for each field implementation that requires custom validation logic.
        def validate(record, value)
        end

        protected def perform_validation(record : Model)
          value = record.get_field_value(id)

          if value.nil? && !@null && @editable
            record.errors.add(id, null_error_message(record), type: :null)
          elsif empty_value?(value) && !@blank && @editable
            record.errors.add(id, blank_error_message(record), type: :blank)
          end

          validate(record, value)
        end

        private def empty_value?(value) : ::Bool
          value.nil?
        end

        private def null_error_message(_record)
          # TODO: add I18n support.
          "This field cannot be null."
        end

        private def blank_error_message(_record)
          # TODO: add I18n support.
          "This field cannot be blank."
        end

        private def raise_unexpected_field_value(value)
          raise Errors::UnexpectedFieldValue.new("Unexpected value received for field '#{id}': #{value}")
        end
      end
    end
  end
end
