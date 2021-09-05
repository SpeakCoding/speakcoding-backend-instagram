class CreateLikes < ActiveRecord::Migration[6.0]
  def change()
    create_table(:likes) do |t|
      t.bigint(:post_id)
      t.bigint(:user_id)

      t.timestamps()
    end

    add_index(:likes, [:post_id, :user_id])

    add_column(:posts, :likes_count, :bigint, default: 0)
  end
end
