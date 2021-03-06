class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  mount_uploader :avatar, AvatarUploader

  has_many :speeches
  has_many :services, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name:  Relationship.name,
    foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  belongs_to :location

  validates :slug, presence: true
  validates :email, unique: false

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :omniauthable

  acts_as_paranoid
  rolify
  enum position: {developer: 0, team_leader: 1, project_manager: 2,
    group_leader: 3, section_manager: 4, division_manager: 5, ceo: 6},
    _suffix: true

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end
end
