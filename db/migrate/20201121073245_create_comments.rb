class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.bigint :user_id
      t.bigint :post_id
      t.string :body, null: false

      t.timestamps
    end

    add_index :comments, [:post_id, :created_at]

    add_column :posts, :comments_count, :bigint, null: false, default: 0
  end
end
