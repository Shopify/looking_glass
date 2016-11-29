module LookingGlass
  # A class to reflect on instance, class, and class instance variables,
  # as well as constants.
  class FieldMirror < Mirror
    Field = Struct.new(:object, :name)

    attr_reader :name

    def initialize(obj)
      super
      @object = obj.object
      @name = obj.name.to_s
    end

    # @return [ClassMirror] The class this method was originally defined in
    def defining_class
      LookingGlass.reflect(@object)
    end
  end
end

require 'looking_glass/field_mirror/class_variable_mirror'
require 'looking_glass/field_mirror/instance_variable_mirror'
require 'looking_glass/field_mirror/constant_mirror'
