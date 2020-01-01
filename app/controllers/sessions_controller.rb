class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  	# 有効なユーザである　かつ　正しいパスワード
  		# ユーザーログイン後にユーザー情報のページにリダイレクト
  		log_in user
  		redirect_to user
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		# flash.nowでエラーメッセージの表示
  		# レンダリングが終わっているページで特別にフラッシュメッセージを表示できる
  		render 'new'
  	end
  end

  def destroy
  		log_out
  		redirect_to root_path
  end
end
