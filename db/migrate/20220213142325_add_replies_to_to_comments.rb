class AddRepliesToToComments < ActiveRecord::Migration[6.0]
  def change
    add_column(:comments, :reply_id, :bigint)
  end
end
