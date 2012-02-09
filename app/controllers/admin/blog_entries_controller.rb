class Admin::BlogEntriesController < Admin::BaseController
  resource_controller

  index.before do 
    @blog_entries = BlogEntry.find(:all, :order => "created_at DESC")
  end
  
  
  create.wants.html { redirect_to admin_blog_entries_path }

  
  update.before do 
    if params[:blog_entry].select{|k,v| k.to_s.match(/^created_at/) }.any?
      b = BlogEntry.find_by_id(params[:id])
      b.created_at = DateTime.new().change(:year=>params[:blog_entry]["created_at(1i)"].to_i, :month=>params[:blog_entry]["created_at(2i)"].to_i, :day=>params[:blog_entry]["created_at(3i)"].to_i)
      b.save
    end
    params[:blog_entry].reject!{|k,v| k.to_s.match(/^created_at/i) }
  end
  
  update.wants.html { redirect_to admin_blog_entries_path  }
  
  new_action.before do
    @blog_entry.build_blog_entry_image
  end 
  
  
  def toggle_main
    b = BlogEntry.find_by_id(params[:id])
    b.update_attributes!(:to_main=>!b.to_main)
    render :json=>{:success=>true, :val=>b.to_main}
  end
end
