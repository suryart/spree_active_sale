module Spree
  class SaleImage < Asset
    validates_attachment_presence :attachment
    validate :no_attachment_errors

    attr_accessible :alt, :attachment, :position, :viewable_type, :viewable_id

    has_attached_file :attachment,
                      :styles => { :mini => '48x48>', :small => '100x100>', :sale => '240x240>', :large => '600x600>' },
                      :default_style => :sale,
                      :url => '/spree/sales/:id/:style/:basename.:extension',
                      :path => ':rails_root/public/spree/sales/:id/:style/:basename.:extension',
                      :convert_options => { :all => '-strip' }
    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet
    after_post_process :find_dimensions

    include Spree::Core::S3Support
    supports_s3 :attachment

    #used by admin sales autocomplete
    def mini_url
      attachment.url(:mini, false)
    end

    def find_dimensions
      temporary = attachment.queued_for_write[:original]
      filename = temporary.path unless temporary.nil?
      filename = attachment.path if filename.blank?
      geometry = Paperclip::Geometry.from_file(filename)
      self.attachment_width  = geometry.width
      self.attachment_height = geometry.height
    end

    # if there are errors from the plugin, then add a more meaningful message
    def no_attachment_errors
      unless attachment.errors.empty?
        # uncomment this to get rid of the less-than-useful interrim messages
        # errors.clear
        errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
        false
      end
    end

    def viewable_type=(event_type)
      super event_type.to_s.classify.constantize.base_class.to_s
    end
  end
end
