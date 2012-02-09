class AddToMainPageToBlogEntries2 < ActiveRecord::Migration
  def self.up
    remove_column :blog_entries, :to_main
    change_table :blog_entries do |t|
      t.boolean :to_main , :default=>false, :null=>false
    end
  end

  def self.down
    remove_column :blog_entries, :to_main
  end
end
