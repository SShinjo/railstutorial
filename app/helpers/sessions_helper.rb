module SessionsHelper

# 渡されたユーザーでログインする
def log_in(user)
	# 一時セッションの中にユーザーIDを置く
	session[:user_id] = user.id
end

# 現在ログイン中のユーザーを返す（いたら）
def current_user
	if session[:user_id]
		@current_user ||= User.find_by(id: session[:user_id])
	end
end

# ログイン済みユーザー？
def logged_in?
	!current_user.nil?
end

# current_userをログアウトさせる
def log_out
	session.delete(:user_id)
	@current_user = nil
end

end
