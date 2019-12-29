require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
  	@base_title = "Ruby on Rails Tutorial Sample App"
  end
  # 重複箇所はメソッドでまとめることができる

  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

# 上の２つ。アクションをgetして正常に動作することを確認する。
# アサーション（assertion: 主張、断言）と呼ばれる手法で行う。
# response: success はHTTPコード（200 OK）を表す
# 「Homeページのテスト。GETリクエストをhomeアクションに対して発行（送信）せよ。そうすれば、リクエストに対するレスポンスは「成功」になるはず」

  test "should get about" do
  	get static_pages_about_url
  	assert_response :success
  	assert_select "title", "About | #{@base_title}"
  end

   test "should get contact" do
  	get static_pages_contact_url
  	assert_response :success
  	assert_select "title", "Contact | #{@base_title}"
  end

end

# テストを通すことで安心してリファクタリングを行うことができるようになる。
# ->リファクタリングとは　→ コードを綺麗にすること
# 「外部から見たときの振る舞いを保ちつつ、理解や修正が簡単になるように、ソフトウェアの内部構造を変化させること」
