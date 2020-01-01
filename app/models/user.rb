class User < ApplicationRecord
# ユーザー用のデータモデルを、そのモデルを表示するためのWebインターフェイスに従って実装する。
# データモデルとWebインターフェイスは、組み合わさってUsersリソースとなる。
# ユーザというものをHTTPプロトコル経由で自由に作成・取得・更新・削除できるオブジェクトとみなすことができるようになる。

# 仮想のremeber_token属性を作成する
# passwordの時は、データベース上のセキュアなpassword_digest属性と、password属性の二つが使えた（has_secure_passwordによる）
attr_accessor :remember_token, :activation_token, :reset_token

before_save :downcase_email
# before_save {self.email = email.downcase}
# before_save {email.downcase!} でもOK

# データベースに保存される前に、全ての文字列（アドレス）を小文字化する
# コールバックメソッドの１つ：before_saveを使う
# email.downcase = self.email.downcase
# １）バリデーションの記述、２）アドレスにインデックスを与え、一意性を与える、３）保存する前に小文字化、で２重サブミット問題は解消される（らしい）
before_create :create_activation_digest

has_many :microposts, dependent: :destroy
validates :name, presence: true, length: {maximum: 50}

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
# 正規表現(Regular Expression : regex)コード
# railsチュートリアル リスト6.21を参考に
# Rubular（対話的に正規表現を試せるWebサイト）の利用もOK

validates :email, presence: true, length: {maximum: 255},
format: {with: VALID_EMAIL_REGEX },
# formatオプション：引数に正規表現をとる。
uniqueness: { case_sensitive: false }
# case_sensitiveオプション：　大文字小文字を区別するかどうか（false：区別しない）


has_secure_password
# セキュアパスワード実装のためのメソッド
# １）セキュアにハッシュ化したパスワードをデータベース内のpassword_digestという属性に保存できるようになる。
# ２）２つのペアの仮想的な属性（passwordとpassword_confirmation）が使えるようになる。
# また、存在性と値が一致するかどうかのバリデーションも追加される。
# ３）authenticateメソッドが使えるようになる。
	# （引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド）

validates :password, presence: true, length: { minimum: 6 }

# クラスメソッド作成
# class << self
# 渡された文字列のハッシュ値を返すs
def User.digest(string)
	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
	BCrypt::Password.create(string, cost: cost)
end

# ランダムなトークンを返す
def User.new_token
	SecureRandom.urlsafe_base64
end

# end

# 永続セッションのためにユーザーをデータベースに記憶する
def remember
	self.remember_token = User.new_token
	update_attribute(:remember_digest, User.digest(remember_token))
end

# 渡されたトークンがダイジェストと一致したらtrueを返す
def authenticated?(attribute, token)
	digest = self.send("#{attribute}_digest")
	return false if digest.nil?
	BCrypt::Password.new(digest).is_password?(token)
end

# ユーザーのログイン情報を破棄する
def forget
	update_attribute(:remember_digest, nil)
end

# アカウントを有効にする
def activate
	update_columns(:activated, true, :activated_at, Time.zone.now)
end

# 有効化用のメールを送信する
def send_activation_email
	UserMailer.account_activation(self).deliver_now
end

# パスワード再設定の属性を設定する
def create_reset_digest
	self.reset_token = User.new_token
	update_attribute(:reset_digest, User.digest(reset_token))
	update_attribute(:reset_sent_at, Time.zone.now)
end

# パスワード再設定のメールを送信する
def send_password_reset_email
	UserMailer.password_reset(self).deliver_now
end

# パスワード再設定の期限が切れてたらtrueを返す
def password_reset_expired?
	# パスワード再設定メールの送信時刻が、現在時刻より２時間以上前の場合
	reset_sent_at < 2.hours.ago
end

# 疑問符をつけることで、SQLクエリに代入する前にidがエスケープされる
def feed
	Micropost.where("user_id = ?", id)
end

private

# メールアドレスを全て小文字にする
def downcase_email
	self.email = email.downcase
end

# 有効化トークンとダイジェストを作成及び代入する
def create_activation_digest
	self.activation_token = User.new_token
	self.activation_digest = User.digest(activation_token)
end


end
