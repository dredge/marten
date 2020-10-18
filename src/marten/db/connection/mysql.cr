module Marten
  module DB
    module Connection
      class MySQL < Base
        def insert(table_name : String, values : Hash(String, ::DB::Any), pk_field_to_fetch : String? = nil) : Int64?
          column_names = values.keys.map { |column_name| "#{quote(column_name)}" }.join(", ")
          numbered_values = values.keys.map_with_index { |_c, i| parameter_id_for_ordered_argument(i + 1) }.join(", ")
          statement = "INSERT INTO #{quote(table_name)} (#{column_names}) VALUES (#{numbered_values})"

          new_record_id = nil

          open do |db|
            db.exec(statement, args: values.values)
            new_record_id = unless pk_field_to_fetch.nil?
              db.scalar("SELECT LAST_INSERT_ID()").as(Int32 | Int64).to_i64
            end
          end

          new_record_id
        end

        def introspector : Management::Introspector::Base
          Management::Introspector::MySQL.new(self)
        end

        def left_operand_for(id : String, _predicate) : String
          id
        end

        def operator_for(predicate) : String
          PREDICATE_TO_OPERATOR_MAPPING[predicate]
        end

        def parameter_id_for_ordered_argument(number : Int) : String
          "?"
        end

        def quote_char : Char
          '`'
        end

        def schema_editor : Management::SchemaEditor::Base
          Management::SchemaEditor::MySQL.new(self)
        end

        def scheme : String
          "mysql"
        end

        def update(
          table_name : String,
          values : Hash(String, ::DB::Any),
          pk_column_name : String,
          pk_value : ::DB::Any
        ) : Nil
          column_names = values.keys.map_with_index do |column_name, i|
            "#{quote(column_name)}=#{parameter_id_for_ordered_argument(i + 1)}"
          end.join(", ")

          statement = "UPDATE #{quote(table_name)} SET #{column_names} " \
                      "WHERE #{quote(pk_column_name)}=#{parameter_id_for_ordered_argument(values.size + 1)}"

          open do |db|
            db.exec(statement, args: values.values + [pk_value])
          end
        end

        private PREDICATE_TO_OPERATOR_MAPPING = {
          "contains"    => "LIKE BINARY %s",
          "endswith":      "LIKE BINARY %s",
          "exact"       => "= %s",
          "icontains"   => "LIKE %s",
          "iendswith":     "LIKE %s",
          "iexact"      => "LIKE %s",
          "istartswith" => "LIKE %s",
          "startswith"  => "LIKE BINARY %s",
        }
      end
    end
  end
end