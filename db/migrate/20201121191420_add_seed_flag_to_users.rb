class AddSeedFlagToUsers < ActiveRecord::Migration[6.0]
  def change()
    add_column(:users, :seed, :boolean, null: false, default: false)
  end
end
