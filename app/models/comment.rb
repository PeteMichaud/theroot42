class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id, :tag_list

  belongs_to :user
  has_many :votes
  has_many :taggings, order: 'position'
  has_many :tags, through: :taggings, uniq: true

  validates :content, presence: true
  validates :user_id, presence: true

  before_save :order_taggings

  # Class Methods

  def self.tagged_with tags, opts = {}

    # Build Options
    opts = {
        get_tags: false,
        get_total: false,
        page: 0
    }.merge(opts)

    tag_array = Tag.to_tag_array(tags, opts)

    # Collect all comments
    comments =  Comment.joins(:taggings).
                        where('taggings.tag_id' => tag_array)

    total = comments.count if opts[:get_total]

    comments = comments.limit(Theroot::Application.config.page_size).
                        offset(opts[:page] * Theroot::Application.config.page_size)

    ret = [] << comments
    ret << tag_array if opts[:get_tags]
    ret << total if opts[:get_total]

    ret.count > 1 ? ret : ret[0]

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
    self.tags << Tag.parse(name).map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
    self.save
  end

  def untag_with name
    delete_tags = Tag.parse(name).map { |n| Tag.where(name: n.strip).first }

    self.taggings.where(:tag_id => delete_tags.map(&:id)).destroy_all
    self.tags.delete_if { |t| delete_tags.include? t }

    # remove unused tags
    delete_tags.each { |tag| tag.destroy if tag.count < 1 }
  end

  def tagged_with? tag
    (tags & Tag.to_tag_array(tag)).empty?
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

  def vote_from user_id
    user_id = user_id.id if user_id.is_a? User
    vote = votes.where(user_id: user_id).first
    vote || Vote.new({comment_id: self.id})
  end

  private

  def vote value, user_id
    vote = Vote.new_or_destroy({value: value, user_id: user_id, comment_id: self.id})
    vote.save! if vote.is_a? Vote
    vote
  end

  def order_taggings
    taggings.each_with_index do |t, i|
      t.position = i
    end
  end

end
