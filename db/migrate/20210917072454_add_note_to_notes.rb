class AddNoteToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :title, :string
    add_column :notes, :content, :string
    add_column :notes, :tags, :string ,array: true, default: []
    add_reference :notes, :user, null: false, foreign_key: true
  end
end
