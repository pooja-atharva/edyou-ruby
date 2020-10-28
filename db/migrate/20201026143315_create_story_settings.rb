class CreateStorySettings < ActiveRecord::Migration[6.0]
  def change
    create_table :story_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :share_public_story, default: true
      t.boolean :share_mentioned_story, default: true

      t.timestamps
    end
  end
end
