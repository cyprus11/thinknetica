module Accessors
  def attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      var_attr = "@#{attr}".to_sym
      var_attr_history = "#{var_attr}_history".to_sym
      define_method(attr) { instance_variable_get(var_attr) }
      define_method("#{attr}_history".to_sym) { instance_variable_get(var_attr_history) || [] }
      define_method("#{attr}=".to_sym) do |value|
        instance_variable_set(var_attr, value)
        instance_variable_set(var_attr_history, send("#{attr}_history".to_sym) << value)
      end
    end
  end

  def strong_attr_accessor(name, value_class)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise RuntimeError.new("Wrong variable, because class of it is not #{value_class.name}.") unless value.is_a?(value_class)
      instance_variable_set(var_name, value)
    end
  end
end