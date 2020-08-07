class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.references :taggable, polymorphic: true
      t.references :tagger, polymorphic: true
      t.text :context

      t.timestamps
    end
  end
end
