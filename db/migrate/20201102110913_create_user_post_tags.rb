class CreateUserPostTags < ActiveRecord::Migration[6.0]
  def change()
    create_table(:user_post_tags) do |t|
      t.bigint(:user_id, null: false)
      t.bigint(:post_id, null: false)
      t.float(:top, null: false)
      t.float(:left, null: false)

      t.timestamps()
    end

    add_index(:user_post_tags, :post_id)
  end
end
