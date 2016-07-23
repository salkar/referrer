class AddReferrerTrackingTo<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :<%= table_name %>, :referrer_source_id, :integer
    add_index :<%= table_name %>, :referrer_source_id
  end
end