class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :taggings
  has_many :comments, through: :taggings, uniq: true

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
        joins(:taggings).group("taggings.tag_id")
  end

  def count
    Tagging.where(tag_id: self.id).count
  end

  def name= value
    write_attribute(:name, value)
    write_attribute(:param_name, value.parameterize)
  end

end
