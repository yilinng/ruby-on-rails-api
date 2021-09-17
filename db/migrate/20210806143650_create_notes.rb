class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :title
      t.string :content
      t.string :tags, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :notes, :tags, using: 'gin'
  end
end
