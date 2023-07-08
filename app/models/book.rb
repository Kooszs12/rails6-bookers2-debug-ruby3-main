class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body,
  length:{minimum: 1, maximum:200}

  #引数で渡されたユーザidがFavoritesテーブル内に存在するかどうかを調べる
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #検索方法の分岐
  def self.looks(search, word)
    #完全一致→perfect_match
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    #前方一致→forward_match
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    #後方一致→backword_match
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    #部分一致→partial_match
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  #投稿数を数えるメソッド
  #Time.zone.now.all_day = 1日の投稿数を数える
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
    #1.day.ago = 昨日の投稿数を数える
    scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
    #6.day.ago.beginning_of_day..Time.zone.now.end_of_day＝今日から６日前までの投稿数を数える
    scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
    scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
end
