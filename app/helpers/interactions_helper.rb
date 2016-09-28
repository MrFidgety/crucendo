module InteractionsHelper
  
  # Returns the current open interaction
  def get_interaction(user)
    user.interactions.find_by(completed: false)
  end
  
  # Get text for Crucendo buttons
  def commence_crucendo_text
    if get_interaction(current_user)
      'Continue recent Crucendo'
    else
      'Begin a new Crucendo'
    end
  end
  
end
