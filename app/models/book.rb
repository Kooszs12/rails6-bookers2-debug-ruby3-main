class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :body,
  length:{minimum: 1, maximum:200}

  #引数で渡されたユーザidがFavoritesテーブル内に存在するかどうかを調べる
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
