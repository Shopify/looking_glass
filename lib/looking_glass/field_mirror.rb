class LookingGlass
  # A class to reflect on instance, class, and class instance variables,
  # as well as constants.
  class FieldMirror < Mirror
    Field = Struct.new(:object, :name)
    reflect! Field

    def self.mirror_class(field)
      return unless reflects? field
      case field.name.to_s
      when /^@@/ then ClassVariableMirror
      when /^@/  then InstanceVariableMirror
      else            ConstantMirror
      end
    end

    def initialize(obj)
      super
      @object = obj.object
      @name = obj.name.to_s
    end

    def name
      @name
    end
  end
end

require 'looking_glass/field_mirror/class_variable_mirror'
require 'looking_glass/field_mirror/instance_variable_mirror'
require 'looking_glass/field_mirror/constant_mirror'
