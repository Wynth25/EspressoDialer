module Sandboxable
  extend ActiveSupport::Concern

  included do
    default_scope { where(guest_token: Current.guest_token) }
  end
end