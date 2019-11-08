module ActiveRecord
  module Validations
    class UniquenessValidator < ActiveModel::EachValidator 
      def validate_each(record, attribute, value)
        finder_class = find_finder_class_for(record)
        value = map_enum_attribute(finder_class, attribute, value)
      
        relation = build_relation(finder_class, attribute, value)
        if record.persisted?
          if finder_class.primary_key
            relation = relation.where.not(finder_class.primary_key => record.id_in_database)
          else
            raise UnknownPrimaryKey.new(finder_class, "Cannot validate uniqueness for persisted record without primary key.")
          end
        end
        relation = scope_relation(record, relation)
        relation = relation.merge(options[:conditions]) if options[:conditions]
      
        if relation.exists?
          error_options = options.except(:scope, :conditions)
          error_options[:value] = value
          record.errors.add(attribute, :taken, error_options)
        end
      end
    end
    class AssociatedValidator < ActiveModel::EachValidator #:nodoc:
      def validate_each(record, attribute, value)
        wrong_objects = Array(value).reject { |r| valid_object?(r) }
        if wrong_objects.any?
          errors = []
          wrong_objects.each do |r|
            errors << r.errors.full_messages
          end
          detail_errors = :detail_errors
          record.errors.add(attribute, :invalid, options.merge(value: value, detail_errors: errors))
        end
      end
    end
  end
  class Error
    protected
    def generate_full_message(options = {})
      keys = [
        :"full_messages.#{@message}",
        :'full_messages.format'
      ]
      keys.push('%{attribute} %{message}')
      options.merge!(:default => keys, :message => self.message)
      msg = I18n.translate(keys.shift, options)
      msg
    end
  end
  
  
end