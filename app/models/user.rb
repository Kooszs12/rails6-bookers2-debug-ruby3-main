class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #画像のカラム
  has_one_attached :profile_image
  #投稿との関係
  has_many :books, dependent: :destroy
  #投稿に対するいいねとの関係
  has_many :favorites, dependent: :destroy
  #投稿に対するコメントとの関係
  has_many :book_comments, dependent: :destroy
  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower


  #ユーザー編集に対する制限とバリデーション機能
  validates :name,
    length: { minimum: 2, maximum: 20 },
    uniqueness: true
  validates :introduction,
    length: { maximum: 50 }

  #プロフィール画像についての
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  #検索方法の分岐
  def self.looks(search, word)
    #完全一致→perfect_match
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    #前方一致→forward_match
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    #後方一致→backword_match
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    #部分一致→partial_match
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end
