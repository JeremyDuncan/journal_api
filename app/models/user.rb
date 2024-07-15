class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :single_user_limit, on: :create

  private

  def single_user_limit
    if User.count >= 1
      errors.add(:base, "Only one user is allowed.")
    end
  end
end
