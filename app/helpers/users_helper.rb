module UsersHelper
  
  # Returns the users name if assigned.
  def get_name(user)
    if user.name.blank?
      user.email
    else
      user.name
    end
  end
end
