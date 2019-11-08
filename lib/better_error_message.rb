if defined?(ActiveModel)
  require 'rails/extensions/active_model'
  require 'rails/extensions/active_record'
else
  require 'rails/extensions/active_record'
end