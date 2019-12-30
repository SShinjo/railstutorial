class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
  	# メールアドレスの一意性を強制するためのマイグレーション
  	# index自体は一意性を強制しないけど、unuqueオプションをtrueにすることで実現できる
  	add_index :users, :email, unique: true
  end
end
