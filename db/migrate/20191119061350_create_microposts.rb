class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end

# ＞データベースのマイグレーションの変更
# 	$ rails db:migrate
# ＞元に戻したい（１つ前の状態に戻す）
# 	$ rails db:rollback
# ＞最初の状態に戻したい
# 	$ rails db:migrate VERSION=0
# (マイグレーションは逐次的に実行され、それぞれのマイグレーションに対してバージョン番号が付与される)