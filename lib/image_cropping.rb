module ImageCropping

  module Glue
    def self.included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def has_cropper(attachment_name, *style_names)
      define_method "#{attachment_name}_cropper" do
        return instance_variable_get("@#{attachment_name}_cropper") if instance_variable_defined?("@#{attachment_name}_cropper")
        instance_variable_set("@#{attachment_name}_cropper", Cropper.new(self, attachment_name, *style_names))
      end

      define_method "#{attachment_name}_crop_data=" do |value|
        send("#{attachment_name}_cropper").crop_data = value
      end
      # attr_accessible "#{attachment_name}_crop_data"

      define_method "crop_#{attachment_name}!" do
        send("#{attachment_name}_cropper").crop!
      end
      after_save "crop_#{attachment_name}!"
    end
  end

  class Cropper

    attr_accessor :crop_data
    attr_reader :styles

    def initialize(owner, attachment_name, *style_names)
      @owner = owner
      @attachment_name = attachment_name
      @styles = {}
      style_names.each do |arg|
        if arg.kind_of? Hash
          arg.each do |style_name, inherited_styles|
            style = attachment.styles[style_name]
            @styles[style] = []
            Array.wrap(inherited_styles).each do |inherited_style|
              @styles[style] << attachment.styles[inherited_style]
            end
          end
        else
          style = attachment.styles[arg]
          @styles[style] = []
        end
      end
      @crop_data = {}
    end

    def attachment
      @owner.send @attachment_name
    end

    def crop_attributes(style_name)
      @crop_data[style_name]
    end

    def crop!
      if !@cropped && @crop_data.present?
        @cropped = true
        original_file = File.open attachment.path(:original)
        @styles.each do |style, inherited_styles|
          if @crop_data[style.name].kind_of?(Hash) && @crop_data[style.name][:w].present? && @crop_data[style.name][:h].present? && @crop_data[style.name][:x].present? && @crop_data[style.name][:y].present?
            files = {}
            files[style] = Paperclip.processor(:cropper).make(original_file, style.processor_options.merge(:cropper => self, :style => style), attachment)
            if inherited_styles.present?
              inherited_styles.each do |inherited_style|
                ratio = Paperclip::Geometry.parse(style.geometry).width / Paperclip::Geometry.parse(inherited_style.geometry).width
                @crop_data[inherited_style.name] = {}
                @crop_data[style.name].each do |key, value|
                  @crop_data[inherited_style.name][key] = value.to_f / ratio
                end
                files[inherited_style] = Paperclip.processor(:cropper).make(original_file, inherited_style.processor_options.merge(:cropper => self, :style => style), attachment)
              end
            end
            files.each do |style, file|
              file.close
              FileUtils.mkdir_p File.dirname(attachment.path(style.name))
              FileUtils.cp file.path, attachment.path(style.name)
              FileUtils.chmod 0666&~File.umask, attachment.path(style.name)
              file.unlink
            end
          end
        end
        original_file.close
        @owner.update_attribute "#{@attachment_name}_updated_at", Time.now
        @cropped = false
      end
    end

    def geometry(style_name)
      @geometries ||= {}
      @geometries[style_name] ||= Paperclip::Geometry.from_file attachment.path(style_name)
    end

    def aspect_ratio(style_name)
      geometry = Paperclip::Geometry.parse attachment.styles[style_name].geometry
      geometry.width / geometry.height
    end

  end

end

module Paperclip
  class Cropper < Thumbnail

    def initialize(file, options = {}, attachment = nil)
      super
      @cropper = options[:cropper]
      @style = options[:style]
    end

    def transformation_command
      scale = @current_geometry.transformation_to(@target_geometry, true)[1]
      crop = "'#{@cropper.crop_attributes(@style.name)[:w].to_i}x#{@cropper.crop_attributes(@style.name)[:h].to_i}+#{@cropper.crop_attributes(@style.name)[:x].to_i}+#{@cropper.crop_attributes(@style.name)[:y].to_i}'"
      trans = []
      trans << "-crop" << crop 
      trans << "-resize" << %["#{scale}"]
      trans << "+repage"
      trans
    end
    
  end
end