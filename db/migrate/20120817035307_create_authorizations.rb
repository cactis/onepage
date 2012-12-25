# -*- encoding : utf-8 -*-
class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.belongs_to :user
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :refresh_token
      t.text :_config
      t.timestamp :deleted_at, :default => nil
      t.timestamps
    end

    add_index :authorizations, :user_id
    add_index :authorizations, :provider
    add_index :authorizations, :uid
    add_index :authorizations, :token
    add_index :authorizations, :secret
    add_index :authorizations, :refresh_token

    add_index :authorizations, :deleted_at
    add_index :authorizations, :updated_at
    add_index :authorizations, :created_at
  end
end
