module UsersHelper

# 引数で与えられたユーザーのGravatar画像を返す
def gravatar_for(user, options= {size: 80})
	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
	# gravatar_forメソッドが他から呼び出される可能性を考えて、アドレスを小文字化している
	size = options[:size]
	gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
	image_tag(gravatar_url, alt: user.name, class: "gravatar")
end

end
