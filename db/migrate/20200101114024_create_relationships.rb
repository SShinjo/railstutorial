class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # follower_idとfollowed_idで頻繁に検索することになるのでindex番号を付与
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # 一意な複合キーインデックス　→ あるユーザーが同じユーザーを２回以上フォローするのを阻止
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
