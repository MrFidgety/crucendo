class StaticPagesController < ApplicationController
  def help
  end
  
  def privacy
    send_file(
      "#{Rails.root}/public/The_Crucial_Team_Privacy_Policy_v4_July_2016.pdf",
      filename: "Privacy.pdf",
      type: "application/pdf",
      disposition: :inline
    )
  end
  
  def terms
    send_file(
      "#{Rails.root}/public/The_Crucial_Team_General_Terms_and_Conditions_v3_July_2016.pdf",
      filename: "TermsAndConditions.pdf",
      type: "application/pdf",
      disposition: :inline
    )
  end
end
