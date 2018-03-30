class CreateGithubProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :github_profiles do |t|
      t.integer :user_id
      t.string :username
      t.string :email
      t.string :name
      t.string :image
      t.string :access_token
      t.text :user_data

      t.timestamps
    end
  end
end
