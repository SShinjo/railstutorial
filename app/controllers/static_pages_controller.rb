class StaticPagesController < ApplicationController
  def home
  	@micropost = current_user.microposts.build if logged_in?
  	@feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contact
  end
end

# /static_pages/homeにアクセス
# → StaticPagesコントローラを参照　
# → homeアクションに記述されているコードを実行する