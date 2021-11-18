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
      method_name = "#{attr_name}_#{type}_valid?".to_sym
      define_method(method_name) do
        var_name = "@#{attr_name}".to_sym
        if type == :presence
          return "This variable @#{attr_name} should not be nil." if instance_variable_get(var_name).nil?
        elsif type == :format
          return "This variable @#{attr_name} does not not match format." if instance_variable_get(var_name) !~ options
        elsif type == :type
          return "This variable @#{attr_name} has wrong type." if !instance_variable_get(var_name).is_a?(options)
        end
        false
      end
    end
  end

  module InstanceMethods
    def validate!
      valid_methods = methods.select { |method| method.to_s.include?("_valid?") }

      valid_methods.each do |method|
        result = send(method)
        raise RuntimeError.new(result) if result
      end
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end
  end
end
