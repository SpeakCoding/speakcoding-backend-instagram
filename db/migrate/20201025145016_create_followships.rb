class CreateFollowships < ActiveRecord::Migration[6.0]
  def change()
    create_table(:followships) do |t|
      t.bigint(:follower_id, null: false)
      t.bigint(:followee_id, null: false)

      t.timestamps()
    end

    add_column(:users, :followers_count, :bigint, null: false, default: 0)
    add_column(:users, :followees_count, :bigint, null: false, default: 0)
  end
end
