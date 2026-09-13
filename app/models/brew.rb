class Brew < ApplicationRecord
  include Sandboxable
  belongs_to :recipe
end
