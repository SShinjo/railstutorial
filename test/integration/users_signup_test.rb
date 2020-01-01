require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

# $ rails g integration_test users_signup で生成されたファイル

# 無効なユーザー登録に対するテスト

  test "invalid signup information" do
  	get signup_path
  	# ユーザー登録ページにアクセスする
  	assert_no_difference 'User.count' do
  	post users_path, params: { user: { name: "",
  							   email: "user@invalid",
  							   password: "foo",
  							   password_confirmation: "bar" }}
  	end
  	# フォーム送信テストのため、users_pathに対してPOSTリクエストを送信
  	# assert_no_differenceメソッドのブロック内で、postを使う
  	# メソッドの引数にはUser.countを与えて、値が変わらないことを確認
  	assert_template 'users/new'
  	assert_select 'div#<CSS id for error explanation>'
  	assert_select 'div.<CSS class for field with error>'
  end

# 有効なユーザ登録に対するテスト

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                          email: "user@example.com",
                          password: "password",
                          password_confirmation: "password"}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
