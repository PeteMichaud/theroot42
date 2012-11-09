class Tagging < ActiveRecord::Base
  attr_accessible :comment

  belongs_to :tag
  belongs_to :comment

end
