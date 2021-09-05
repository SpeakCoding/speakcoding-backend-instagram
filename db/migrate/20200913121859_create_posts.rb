class CreatePosts < ActiveRecord::Migration[6.0]
  def change()
    create_table(:posts) do |t|
      t.bigint(:user_id)
      t.string(:caption)
      t.string(:location)

      t.timestamps()
    end
  end
end
