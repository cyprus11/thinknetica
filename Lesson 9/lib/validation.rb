module Validation
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def validate(attr_name, type, options = nil)
      raise RuntimeError.new("This type of validation don't exist.") unless [:presence, :format, :type].include?(type)
      validate_hash = { validation_type: type, var_name: attr_name, params: options }
      validation_data = "@validation_array".to_sym
      instance_variable_set(validation_data, (instance_variable_get(validation_data) || []) << validate_hash)
    end
  end

  module InstanceMethods
    def validate!
      validation_data = "@validation_array".to_sym
      self.class.instance_variable_get(validation_data).each do |validation|
        result = case validation[:validation_type]
          when :presence
            send(:validate_presence, validation[:var_name])
          when :format
            send(:validate_format, validation[:var_name], validation[:params])
          when :type
            send(:validate_type, validation[:var_name], validation[:params])
          end

        raise RuntimeError.new(result) if result
      end
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    def validate_presence(var_name)
      return "This variable @#{var_name} should not be nil." if instance_variable_get("@#{var_name}").nil?
      false
    end

    def validate_format(var_name, format)
      return "This variable @#{var_name} does not not match format." if instance_variable_get("@#{var_name}") !~ format
      false
    end

    def validate_type(var_name, type)
      return "This variable @#{var_name} has wrong type." if !instance_variable_get("@#{var_name}").is_a?(type)
      false
    end
  end
end
