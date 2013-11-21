GalleryItem.class_eval do
  has_attached_file :attachment, 
                    :styles => { :mini => '100x100#', :cropper => '600', :normal => '300x300#', :large => '800x800>' },
                    :default_style => :normal,
                    :url => "/assets/gallery_items/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/gallery_items/:id/:style/:basename.:extension"
  include ImageCropping::Glue
  has_cropper :attachment, :normal => :mini
end