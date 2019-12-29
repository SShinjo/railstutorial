class User < ApplicationRecord
# ユーザー用のデータモデルを、そのモデルを表示するためのWebインターフェイスに従って実装する。
# データモデルとWebインターフェイスは、組み合わさってUsersリソースとなる。
# ユーザというものをHTTPプロトコル経由で自由に作成・取得・更新・削除できるオブジェクトとみなすことができるようになる。

has_many :microposts

validates :name, presence: true
validates :email, presence: true

end
