class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :song, index: true
      t.text :comment_text
      t.boolean :enabled
      t.timestamps
    end
  end
end
