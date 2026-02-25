class AddApiTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :api_token, :string
    add_index :users, :api_token, unique: true

    reversible do |dir|
      dir.up do
        User.reset_column_information
        User.find_each do |user|
          user.update_columns(api_token: SecureRandom.base58(24)) if user.api_token.blank?
        end
        change_column_null :users, :api_token, false
      end
    end
  end
end
