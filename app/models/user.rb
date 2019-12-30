class User < ApplicationRecord
# ユーザー用のデータモデルを、そのモデルを表示するためのWebインターフェイスに従って実装する。
# データモデルとWebインターフェイスは、組み合わさってUsersリソースとなる。
# ユーザというものをHTTPプロトコル経由で自由に作成・取得・更新・削除できるオブジェクトとみなすことができるようになる。

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
end
