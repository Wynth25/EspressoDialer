class Recipe < ApplicationRecord
  belongs_to :bean
  belongs_to :basket
  has_many :brews, dependent: :destroy

  # This returns the newest Brew record for this recipe
  def latest_brew
    brews.order(created_at: :desc).first
  end
end