require 'composite_primary_keys'

class Vote < ActiveRecord::Base
  attr_accessible :value

  self.primary_keys = :user_id, :comment_id

  belongs_to :user
  belongs_to :comment

  validates :user, presence: true
  validates :comment, presence: true

end
