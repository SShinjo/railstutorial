class Relationship < ApplicationRecord
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"

	validates :follower_id, presence: true
	validates :followed_id, presence: true

	# フォローしているユーザーに関して　→ フォローしているユーザーを配列のように扱える
	# followedsとすることで、followed idの集合であると認識されるが、表記が不適切なので、followingとしている
	has_many :following, through: :active_relationships, source: :followed
end
