class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :name, :birthdate, :location, :location_link, :profile, :account_type, :avatar, :active

  has_attached_file :avatar, :styles => { :original => "40x40>" }

  #acts_as_tagger

  has_many :votes
  has_many :comments

  validates :email, presence: true
  validates :name, presence: true
  validates :account_type, presence: true

  def active?
    active
  end

  def activate
    active = true
  end

  def can_modify comment
    return true if account_type != :user
    return true if comment.user_id == self.id
    false
  end

  def self.member_list opts = {}
    opts = {
        page_size: Theroot::Application.config.page_size,
        page: 0,
        filter: nil,
    }.merge opts

    if opts[:page] == :last
      opts[:page] = (User.count.to_f / opts[:page_size]).ceil
    end

    users = User
    users.where("`name` LIKE ? or `email` LIKE ? or `location` LIKE ?", "%#{opts[:filter]}%") if opts[:filter]
    users = users.limit(opts[:page_size]).offset(opts[:page] * opts[:page_size])

    users = UserDecorator.decorate(users)
  end

end
