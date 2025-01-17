class Migration::BarApp::V202108092226111 < Marten::Migration
  depends_on "reader_spec_foo_app", "202108092226111_auto"

  def plan
    create_table :bar_tags do
      column :id, :big_int, primary_key: true, auto: true
      column :label, :string, max_size: 255, unique: true
    end
  end
end
