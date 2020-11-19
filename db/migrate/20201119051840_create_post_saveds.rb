class CreatePostSaveds < ActiveRecord::Migration[6.0]
  def change
    create_table :post_saveds do |t|
      t.bigint :user_id
      t.bigint :post_id
      t.timestamps
    end

    add_index :post_saveds, [:user_id, :created_at]
  end
end
