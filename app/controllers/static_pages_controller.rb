class StaticPagesController < ApplicationController
  def home
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