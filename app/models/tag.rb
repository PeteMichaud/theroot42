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

  def self.to_tag_array tags, opts = {}

    # Build Options
    opts = {
        as_param: false,
        delimiter: '#'
    }.merge(opts)

    # Build array out of whatever was passed in
    name_array = []
    if tags.is_a? Array
      name_array = tags
    elsif tags.is_a? String
      name_array = Tag.parse(tags, opts[:delimiter])
    elsif tags.is_a? Tag
      name_array << tags
    else
      raise "Expecting an array, string, or Tag, got: #{tags.class}"
    end

    # Build an array of Tags from the name array
    if name_array.first.is_a? String
      attr = opts[:as_param] ? 'param_name' : 'name'
      name_array.map! { |n| n.parameterize } if opts[:as_param]
      tag_array = name_array.map do |t|
        Tag.send("find_by_#{attr}", t)
      end.delete_if { |t| t.nil? }
    elsif name_array.first.is_a? Tag
      tag_array = name_array
    else
      raise "Tags must be either strings or Tag objects. Instead got type #{name_array.first.class}"
    end

    tag_array
  end

  def count
    Tagging.where(tag_id: self.id).count
  end

  def name= value
    write_attribute(:name, value)
    write_attribute(:param_name, value.parameterize)
  end

end
