require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

def setup
	@user = User.new(name: "Example User", email: "user@example.com",
					password: "foobar", password_confirmation: "foobar")
end

test "should be valid" do
	assert @user.valid?
end

# 存在性に関するテスト

test "name should be present" do
	@user.name = ""
	assert_not @user.valid?
	# userオブジェクトが有効でなくなったことを確認
	# valid?メソッドで@user変数が有効かどうかをチェック
end

test "email should be present" do
	@user.email = "  "
	assert_not @user.valid?
end

# 長さに関するテスト

test "name should not be too long" do
	@user.name = "a" * 51
	assert_not @user.valid?
end

test "email should not be too long" do
	@user.email = "a" * 244 + "@example.com"
	assert_not @user.valid?
end

#メールアドレスの有効性について

test "email validation should accept valid addresses" do
	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
	valid_addresses.each do |valid_address|
		@user.email = valid_address
		assert @user.valid?, "#{valid_address.inspect} should be valid"
		# assertメソッドの第２引数にエラーメッセージを追加
		# どのアドレスで失敗したのかわかるようになる。
	end
end

# メールアドレスの無効性について

test "email validation reject invalid addresses" do
	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
	invalid_addresses.each do |invalid_address|
		@user.email = invalid_address
		assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
	end
end

# メールアドレスの一意性について

test "email addresses should be unique" do
	duplicate_user = @user.dup
	# ユーザーを複製してる
	duplicate_user.email = @user.email.upcase
	# 大文字小文字を区別させないための記述
	@user.save
	assert_not duplicate_user.valid?
end

# メールアドレスの小文字化に対して

test "email addresses should be saved as lower-case" do
	mixed_case_email = "Foo@ExAMPle.CoM"
	@user.email = mixed_case_email
	@user.save
	assert_equal mixed_case_email.downcase, @user.reload.email

# reload：データベースの値に合わせて更新するメソッド
# assert_equal: 値が一致しているかどうか確認するメソッド
end


# パスワードの最小文字数
	# 空白バージョン
test "password should be present(nonblank)" do
	@user.password = @user.password_confirmation = " " * 6
	assert_not @user.valid?
end
	# 文字数が6文字未満バージョン
test "password sholud be a minimum length" do
	@user.password = @user.password_confirmation = "a" * 5
	assert_not @user.valid?
end

end
