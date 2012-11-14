require 'composite_primary_keys'

class Vote < ActiveRecord::Base
  attr_accessible :value, :user_id, :comment_id

  self.primary_keys = :user_id, :comment_id

  belongs_to :user
  belongs_to :comment

  validates :user, presence: true
  validates :comment, presence: true

  # Unlike most models, votes need to either be created, or if they already exist, they must be destroyed (either you're
  # voting or you're undoing your previous vote)
  def self.new_or_destroy params
    vote = Vote.where(user_id: params[:user_id]).where(comment_id: params[:comment_id]).first

    if vote.nil?
      Vote.new(params)
    else
      vote.destroy
      Vote.new({comment_id: params[:comment_id]})
    end

  end

  def sibling_count
    comment.vote_sum
  end

  def is_dummy?
    user_id == nil
  end

end
