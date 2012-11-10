class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id, :tag_list

  belongs_to :user
  has_many :votes
  has_many :taggings
  has_many :tags, through: :taggings, uniq: true

  validates :content, presence: true
  validates :user_id, presence: true

  # Class Methods

  def self.tagged_with name, opts = {}
    return name.comments if name.is_a? Tag

    default_opts = {
      as_param: false
    }
    opts = default_opts.merge opts

    attr   = opts[:as_param] ? 'param_name' : 'name'
    target = opts[:as_param] ? name.parameterize : name

    Tag.send("find_by_#{attr}!", target).comments
  end

  def self.most_recent_tagged_as tag
    tag = tag.name if tag.is_a? Tag
    Comment.tagged_with(tag).last.created_at
  end

  # Tag Methods

  def tag_list
    tags.map(&:name).join(' #')
  end

  def tag_list=list
    self.tags = []
    tag_with list
  end

  def tag_with name
    self.tags << parse_tags(name).map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def untag_with name
    delete_tags = parse_tags(name).map do |n|
      Tag.where(name: n.strip).first
    end
    self.taggings.where(:tag_id => delete_tags.map(&:id)).destroy_all
    self.tags.delete_if { |t| delete_tags.include? t }
    delete_tags.each do |tag|
      tag
    end
  end

  # Voting Methods

  def vote_sum
    up_votes.size - down_votes.size
  end

  def up_votes
    votes.where(value: true)
  end

  def down_votes
    votes.where(value: false)
  end

  def up_vote user_id
    vote true, user_id
  end

  def down_vote user_id
    vote false, user_id
  end

  private

  def vote value, user_id
    Vote.create!({value: value, user_id: user_id, comment_id: self.id})
  end

  def parse_tags name
    new_tags = []
    if name.is_a? String
      new_tags = name.gsub(/^#/, '').split('#')
    elsif name.is_a? Array
      new_tags = name.map { |n| n.gsub(/^#/, '') }
    else
      raise "Expecting a string or array of tags, got #{name.class}"
    end
    new_tags
  end
end
