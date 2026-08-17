class Basket < ApplicationRecord
  has_many :recipes

  def display_name
    "#{name} #{min_dose}g-#{max_dose}g"
  end
end