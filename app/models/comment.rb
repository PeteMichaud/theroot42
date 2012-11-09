class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id, :tag_list

  acts_as_ordered_taggable

  belongs_to :user
  has_many :votes

  validates :content, presence: true
  validates :user_id, presence: true

  def self.most_recent_with_tag tag
    Comment.tagged_with("\"#{tag}\"").order('created_at DESC').first.created_at
  end

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

end
