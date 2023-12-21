class Connection < ActiveRecord::Base
  def unauthorized?
    access_token.blank? || public_key.blank?
  end

  def authorized?
    !unauthorized?
  end
end
