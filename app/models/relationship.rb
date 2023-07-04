class Relationship < ApplicationRecord

   # class_name: "User"でUserモデルのデータを取り出す
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

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

end
