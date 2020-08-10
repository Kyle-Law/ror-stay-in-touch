class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships, dependent: :destroy

  
  has_many :confirmed_friendships, -> { where(status: true) }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  def sent_friend_requests
    Friendship.where(['user_id = ? and status = ?', id, false])
  end

  def incoming_friend_requests
    Friendship.where(['friend_id = ? and status = ?', id, false])
  end
end