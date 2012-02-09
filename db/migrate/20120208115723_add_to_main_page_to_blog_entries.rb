class AddToMainPageToBlogEntries < ActiveRecord::Migration
  def self.up
    change_table :blog_entries do |t|
      t.boolean :to_main 
    end
  end

  def self.down
    remove_column :blog_entries, :to_main
  end
end
