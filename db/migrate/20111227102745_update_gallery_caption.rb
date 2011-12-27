class UpdateGalleryCaption < ActiveRecord::Migration
  def self.up
    remove_column :galleries, :caption
    add_column :galleries, :caption, :text
  end

  def self.down
    # And... Nothing!
  end
end
