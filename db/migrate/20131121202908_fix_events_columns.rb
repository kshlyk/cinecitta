class FixEventsColumns < ActiveRecord::Migration
  def self.up
    [:venue, :sponsor, :further_information, :summary, :full_description, :visible, 
     :image_file_name, :image_content_type, :image_file_size, :image_updated_at, 
     :end_event
    ].each do |column|
      remove_column :events, column
    end

    rename_column :events, :title, :name
    rename_column :events, :begin_event, :date
    change_column :events, :date, :date
    rename_column :events, :start_time, :time
  end

  def self.down
    add_column :events, :venue, :text
    add_column :events, :sponsor, :string
    add_column :events, :further_information, :string
    add_column :events, :summary, :text
    add_column :events, :full_description, :text
    add_column :events, :visible, :boolean
    add_column :events, :image_file_name, :string
    add_column :events, :image_content_type, :string
    add_column :events, :image_file_size, :integer
    add_column :events, :image_updated_at, :datetime
    add_column :events, :begin_event, :datetime
    add_column :events, :end_event, :datetime

    rename_column :events, :name, :title
    change_column :events, :date, :datetime
    rename_column :events, :date, :begin_event
    rename_column :events, :time, :start_time
  end
end
