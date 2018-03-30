class GithubProfile < ApplicationRecord
  belongs_to :user
  serialize :user_data, Hash
end
