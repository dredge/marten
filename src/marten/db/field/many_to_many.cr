module Marten
  module DB
    module Field
      class ManyToMany < Base
        def initialize(
          @id : ::String,
          @to : Model.class,
          @through : Model.class,
          @primary_key = false,
          @blank = false,
          @null = false,
          @unique = false,
          @editable = true,
          @db_column = nil,
          @db_index = true,
          @related : Nil | ::String | Symbol = nil
        )
          @related = @related.try(&.to_s)
        end

        def default
          # No-op
        end

        def from_db_result_set(result_set : ::DB::ResultSet) : Int32 | Int64 | Nil
          # No-op
        end

        def relation?
          true
        end

        def relation_name
          @id
        end

        def to_column : Management::Column::Base?
          # No-op
        end

        def to_db(value) : ::DB::Any
          # No-op
        end

        # :nodoc:
        macro check_definition(field_id, kwargs)
          {% if kwargs.is_a?(NilLiteral) || kwargs[:to].is_a?(NilLiteral) %}
            {% raise "A related model must be specified for many to many fields ('to' option)" %}
          {% end %}
        end

        # :nodoc:
        macro contribute_to_model(model_klass, field_id, field_ann, kwargs)
          {% through_model = kwargs[:through] %}

          {% if through_model.is_a?(NilLiteral) %}
            # Automatically creates a "through" model to manage the many-to-many relationship between the considered
            # model and the related model.

            {% related_model_klass = kwargs[:to] %}

            {% from_model_name = model_klass.stringify %}
            {% to_model_name = related_model_klass.stringify %}

            {% field_id_string = field_id.stringify %}

            {% through_model_name = "#{model_klass}#{field_id_string.capitalize.id}" %}
            {% through_related_name = "#{from_model_name.downcase.id}_#{field_id_string.downcase.id}" %}
            {% through_model_table_name = "#{from_model_name.downcase.id}_#{field_id_string.downcase.id}" %}
            {% through_model_from_field_id = from_model_name.downcase %}
            {% through_model_to_field_id = to_model_name.downcase %}

            {% if through_model_from_field_id == through_model_to_field_id %}
              {% through_model_from_field_id = "from_#{through_model_from_field_id}" %}
              {% through_model_to_field_id = "to_#{through_model_to_field_id}" %}
            {% end %}

            class ::{{ through_model_name.id }} < Marten::DB::Model
              field :id, :big_auto, primary_key: true
              field(
                :{{ through_model_from_field_id.id }},
                :one_to_many,
                to: {{ model_klass }},
                on_delete: :cascade,
                related: {{ through_related_name }}
              )
              field(
                :{{ through_model_to_field_id.id }},
                :one_to_many,
                to: {{ related_model_klass }},
                on_delete: :cascade,
                related: {{ through_related_name }}
              )
            end
          {% end %}

          class ::{{ model_klass }}
            register_field(
              {{ @type }}.new(
                {{ field_id.stringify }},
                {% unless kwargs.is_a?(NilLiteral) %}**{{ kwargs }}{% end %},
                through: {{ through_model_name.id }}
              )
            )
          end
        end
      end
    end
  end
end
