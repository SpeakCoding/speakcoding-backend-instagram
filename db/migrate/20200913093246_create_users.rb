class CreateUsers < ActiveRecord::Migration[6.0]
  def change()
    create_table(:users) do |t|
      t.string(:user_name)
      t.string(:bio)
      t.string(:email)
      t.string(:password_digest)
      t.string(:authentication_token)

      t.timestamps()
    end

    add_index(:users, :email, unique: true)
    add_index(:users, :authentication_token, unique: true)
  end
end
