Admin::GalleryItemsController.class_eval do
  
  before_filter :load_object, :only => [:crop]

  create.response do |wants|
    wants.html {redirect_to after_save_url}
  end

  update.response do |wants|
    wants.html {redirect_to after_save_url}
  end

  def crop
  end

  private

    def after_save_url
      params[:gallery_item][:attachment].present? ? crop_admin_gallery_gallery_item_url(@gallery, @gallery_item) : admin_gallery_gallery_items_url(@gallery)
    end

end