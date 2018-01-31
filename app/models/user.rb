class User < ActiveRecord::Base

  has_many :videos

  def self.omniauth(auth)
    User.find_or_create_by!(uid: auth['uid'], provider: auth['provider'])
  end

end
