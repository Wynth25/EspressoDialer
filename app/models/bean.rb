class Bean < ApplicationRecord
  has_many :recipes, dependent: :destroy
  
  validate :freeze_date_after_roast_date

  # Automatically archive associated recipes when bean is archived
  after_update :archive_recipes, if: -> { archived? && saved_change_to_archived? }

  def archive_recipes
    recipes.update_all(archived: true) # Make sure your recipes table has an 'archived' boolean column, or handle accordingly
  end

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

  private

  def freeze_date_after_roast_date
    date_to_check = frozen_on || freeze_date
    
    if date_to_check.present? && roast_date.present? && date_to_check < roast_date
      errors.add(:frozen_on, "can't be before the roast date")
    end
  end
  
end