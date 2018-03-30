class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :github_profile
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def update_github_info(auth)
    if auth.extra.present?
      self.github_profile ||= self.build_github_profile
      self.github_profile.update_attributes(user_id: self.id, username: auth.info.nickname, email: auth.info.email, name: auth.info.name, image: auth.info.image, access_token: auth.credentials.token, user_data: auth.extra.raw_info)
    end
  end

  def github_user?
    self.provider == "github" ? true : false
  end

  def github_userdata_exist?
    github_profile && github_profile.user_data.present?
  end
  
  def full_name
    github_profile.name if github_profile.present?
  end

  def username
    github_profile.username if github_profile.present? 
  end

  def bio
    github_profile.user_data.bio if github_userdata_exist?
  end

  def public_repos
    github_profile.user_data.public_repos if github_userdata_exist? 
  end

  def github_profile_image
    github_profile.user_data.avatar_url if github_userdata_exist?
  end

  def total_followers
    github_profile.user_data.followers if github_userdata_exist?
  end

  def total_following
    github_profile.user_data.following if github_userdata_exist?
  end

  def member_since
    github_profile.user_data.created_at.to_date.strftime("%d %B %Y") if github_userdata_exist?
  end

  def location
    github_profile.user_data.location if github_userdata_exist?
  end

  def public_repo_url
    github_profile.user_data.repos_url if github_userdata_exist?
  end

  # ["login", "id", "avatar_url", "gravatar_id", "url", "html_url", "followers_url", "following_url", "gists_url", "starred_url", "subscriptions_url", "organizations_url", "repos_url", "events_url", "received_events_url", "type", "site_admin", "name", "company", "blog", "location", "email", "hireable", "bio", "public_repos", "public_gists", "followers", "following", "created_at", "updated_at", "private_gists", "total_private_repos", "owned_private_repos", "disk_usage", "collaborators", "two_factor_authentication", "plan"]
end
