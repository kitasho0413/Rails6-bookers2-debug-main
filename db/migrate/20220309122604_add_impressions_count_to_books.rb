class AddImpressionsCountToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :impressions_count, :integer, default: 0
  end
end
