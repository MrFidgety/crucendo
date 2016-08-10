module InteractionsHelper
  
  # Returns the current open interaction
  def get_interaction(user)
    user.interactions.find_by(completed: false)
  end
  
end
