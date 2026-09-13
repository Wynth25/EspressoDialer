class Basket < ApplicationRecord
  include Sandboxable
  has_many :brews, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :beans, through: :recipes
  has_many :recipes

  def display_name
    "#{name} #{min_dose}g-#{max_dose}g"
  end
end