class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :trips, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_one_attached :photo

  validates :password,
            format: {
              with: /\A(?=.*\d).+\z/,
              message: "must contain at least one number"
            },
            if: -> { password.present? }
end
