class Admin::GalleriesController < Admin::BaseController
  resource_controller

  create.response do |format|
    format.html { redirect_to [:admin, object, :gallery_items] }
  end
  
  update.response do |format|
    format.html { redirect_to collection_url}
  end
  

end
