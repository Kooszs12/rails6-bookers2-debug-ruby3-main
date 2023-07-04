class Relationship < ApplicationRecord

   # class_name: "User"でUserモデルのデータを取り出す
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
end
