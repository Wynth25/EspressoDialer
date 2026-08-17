class Bean < ApplicationRecord
  has_many :recipes, dependent: :destroy

  def effective_age_in_days
    return 0 unless roast_date
    
    # If it was frozen, calculate days between roast and freeze
    if frozen_on.present?
      (frozen_on - roast_date).to_i
    else
      # Otherwise, calculate days from roast to today
      (Date.today - roast_date).to_i
    end
  end
end