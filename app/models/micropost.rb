class Micropost < ApplicationRecord

belongs_to :user

# 投稿日時によって並び替え（降順）　文法はラムダ式(Procオブジェクトを返す)
default_scope -> { order(created_at: :desc) }

mount_uploader :picture, PictureUploader
validates :user_id, presence: true
validates :content, length: { maximum: 140}, presence: true
validates :picture_size

private
	# アップデートされた画像のサイズをバリデーションする
	def picture_size
		if picture.size > 5.megabytes
			errors.add(:picture, "should be less than 5MB")
		end
	end

end
