class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :taggings
  has_many :comments, through: :taggings, uniq: true

  def self.tag_counts limit = nil
    Tag.select("tags.*, count(taggings.tag_id) as count").
        joins(:taggings).group("taggings.tag_id").order("count DESC").limit(limit)
  end

  def self.parse tags, delimiter = '#'
    new_tags = []
    if tags.is_a? String
      new_tags = tags.gsub(/^#{delimiter}/, '').split(delimiter)
    elsif tags.is_a? Array
      new_tags = tags.map { |n| n.gsub(/^#{delimiter}/, '') }
    else
      raise "Expecting a string or array of tags, got #{tags.class}"
    end
    new_tags
  end

  def count
    Tagging.where(tag_id: self.id).count
  end

  def name= value
    write_attribute(:name, value)
    write_attribute(:param_name, value.parameterize)
  end

end
