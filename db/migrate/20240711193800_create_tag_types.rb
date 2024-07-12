class CreateTagTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :tag_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
