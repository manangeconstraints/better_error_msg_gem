module ActiveModel
  class Errors
    def full_messages
      full_messages = []
      i = 0
      details = @details.map{|k,v| v}.flatten
      each do |attribute, messages|
        detail = details[i]
        i += 1
        messages = Array.wrap(messages)
        next if messages.empty?
            
        if attribute == :base
          messages.each {|m| full_messages << m }
        else          
          attr_name = attribute.to_s.gsub('.', '_').humanize
          attr_name = @base.class.human_attribute_name(attribute, :default => attr_name)
          options = { :default => "%{attribute} %{message}", :attribute => attr_name }
          #full_messages << detail.to_s
          messages.each do |m|
            if detail[:error] == :inclusion
                in_list = detail[:in] ||  detail[:within]
                m += " should be one of [#{in_list.join(', ')}]" 
                full_messages << I18n.t(:"errors.format", options.merge(:message => m))
            elsif detail[:error] == :exclusion
                out_list = detail[:in] || detail[:within]
                m += " cannot be one of [#{out_list.join(', ')}]" 
                full_messages << I18n.t(:"errors.format", options.merge(:message => m))
            elsif detail[:error] == :confirmation  || detail[:error] == :taken
                case_sensitive = detail[:case_sensitive]
                msg = ""
                if case_sensitive != nil
                  if case_sensitive == true
                    is_string = "is"
                  else
                    is_string = "isn't"
                  end
                  original_field = attr_name.split(" ")[0]
                  msg = "(#{original_field} #{is_string} case sensitive)"
                end
                m += msg
                #full_messages << detail.to_s
                
                full_messages << I18n.t(:"errors.format", options.merge(:message => m))
            elsif detail[:error] == :invalid
              detail_errors = detail[:detail_errors]
              if detail_errors
                m += ", because #{detail_errors.join("; ")}"
              end
              full_messages << I18n.t(:"errors.format", options.merge(:message => m))
            else        
                full_messages << I18n.t(:"errors.format", options.merge(:message => m))
            end

          end
        end
      end
      full_messages
    end
  end
  # rewrite the inclusion validator to get the options with the in/within values
  # the original code is : https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/inclusion.rb
  #       class InclusionValidator < EachValidator # :nodoc:
  #       include Clusivity

  #       def validate_each(record, attribute, value)
  #         unless include?(record, value)
  #           record.errors.add(attribute, :inclusion, options.except(:in, :within).merge!(value: value))
  #         end
  #       end
  #     end

  module Validations
    class InclusionValidator < EachValidator 
      def validate_each(record, attribute, value)
        unless include?(record, value)
          record.errors.add(attribute, :inclusion, options.merge(value: value))
        end
      end
    end
    # the original file is: https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/exclusion.rb
    # class ExclusionValidator < EachValidator # :nodoc:
    #   include Clusivity

    #   def validate_each(record, attribute, value)
    #     if include?(record, value)
    #       record.errors.add(attribute, :exclusion, options.except(:in, :within).merge!(value: value))
    #     end
    #   end
    # end    
    class ExclusionValidator < EachValidator # :nodoc:
        def validate_each(record, attribute, value)
          if include?(record, value)
            record.errors.add(attribute, :exclusion, options.merge(value: value))
          end
        end
    end

    # original file is: https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/confirmation.rb
    # rewrite ConfirmationValidator to 
    class ConfirmationValidator < EachValidator
        def validate_each(record, attribute, value)
            unless (confirmed = record.send("#{attribute}_confirmation")).nil?
              unless confirmation_value_equal?(record, attribute, value, confirmed)
                human_attribute_name = record.class.human_attribute_name(attribute)
                record.errors.add(:"#{attribute}_confirmation", :confirmation, options.merge(attribute: human_attribute_name))
              end
            end
          end
    end
  end
end
