class AddColorToTagTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :tag_types, :color, :string
  end
end
