module InstanceCounter
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def instances
      unless class_variable_defined?("@@#{name.downcase}_instances")
        0
      else
        class_variable_get("@@#{name.downcase}_instances")
      end
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.create_class_variable unless self.class.class_variable_defined?("@@#{self.class.name.downcase}_instances")
      self.class.class_variable_set("@@#{self.class.name.downcase}_instances", self.class.class_variable_get("@@#{self.class.name.downcase}_instances") + 1 )
    end

    def create_class_variable
      self.class.class_variable_set("@@#{self.class.name.downcase}_instances", 0)
    end
  end
end