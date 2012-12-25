# -*- encoding : utf-8 -*-
class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.belongs_to :user
      t.belongs_to :snippet
      t.belongs_to :fork
      t.belongs_to :layout
      t.string :type
      t.string :title, :limit => 256
      t.text :description
      t.string :file_name
      t.string :file_type
      t.text :content
      t.boolean :locked
      t.text :settings, :limit => 16.megabyte
      t.timestamps
    end

    add_index :snippets, :user_id
    add_index :snippets, :snippet_id
    add_index :snippets, :fork_id
    add_index :snippets, :layout_id
    add_index :snippets, :type
    add_index :snippets, :title
    add_index :snippets, :file_name
    add_index :snippets, :file_type
    add_index :snippets, :locked
    add_index :snippets, :updated_at
    add_index :snippets, :created_at

  end

  def self.down
    drop_table :snippets
  end
end
