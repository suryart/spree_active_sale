module Spree
  module Admin
    ResourceController.class_eval do

      private
        def get_eventable_object(object_name = {})
          unless object_name[:eventable_type].nil?
            eventable = "#{object_name[:eventable_type]}".constantize.find_by_name(object_name[:eventable_name])
            object_name.delete(:eventable_name)
            unless eventable.nil?
              object_name.merge!(:eventable_id => eventable.id, :permalink => eventable.permalink)
            else
              object_name.merge!(:eventable_id => nil)
            end
          end
        end
    end
  end
end