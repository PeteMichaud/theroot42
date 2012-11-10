class Tagging < ActiveRecord::Base
  attr_accessible :comment, :position

  belongs_to :tag
  belongs_to :comment

end
