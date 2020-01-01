class User < ApplicationRecord
# ユーザー用のデータモデルを、そのモデルを表示するためのWebインターフェイスに従って実装する。
# データモデルとWebインターフェイスは、組み合わさってUsersリソースとなる。
# ユーザというものをHTTPプロトコル経由で自由に作成・取得・更新・削除できるオブジェクトとみなすことができるようになる。

# 仮想のremeber_token属性を作成する
# passwordの時は、データベース上のセキュアなpassword_digest属性と、password属性の二つが使えた（has_secure_passwordによる）
attr_accessor :remember_token


before_save {self.email = email.downcase}
# before_save {email.downcase!} でもOK

# データベースに保存される前に、全ての文字列（アドレス）を小文字化する
# コールバックメソッドの１つ：before_saveを使う
# email.downcase = self.email.downcase
# １）バリデーションの記述、２）アドレスにインデックスを与え、一意性を与える、３）保存する前に小文字化、で２重サブミット問題は解消される（らしい）


has_many :microposts

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
class << self
# 渡された文字列のハッシュ値を返すs
def digest(string)
	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
	BCrypt::Password.create(string, cost: cost)
end

# ランダムなトークンを返す
def new_token
	SecureRandom.urlsafe_base64
end

end

# 永続セッションのためにユーザーをデータベースに記憶する
def remember
	self.remember_token = User.new_token
	update_attribute(:remember_digest, User.digest(remember_token))
end

# 渡されたトークンがダイジェストと一致したらtrueを返す
def authenticated?(remember_token)
	return false if remember_digest.nil?
	BCrypt::Password.new(remember_digest).is_password?(remember_token)
end

# ユーザーのログイン情報を破棄する
def forget
	update_attribute(:remember_digest, nil)
end

end
