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

end
