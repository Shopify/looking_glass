require 'looking_glass/mirror'
require 'looking_glass/object_mirror'
require 'looking_glass/class_mirror'
require 'looking_glass/field_mirror'
require 'looking_glass/method_mirror'

module LookingGlass
  extend self

  # This method can be used to query the system for known modules. It
  # is not guaranteed that all possible modules are returned.
  #
  # @return [Array<ClassMirror>] a list of class mirrors
  def modules
    instances_of(Module)
  end

  # This method can be used to query the system for known classes. It
  # is not guaranteed that all possible classes are returned.
  #
  # @return [Array<ClassMirror>] a list of class mirrors
  def classes
    instances_of(Class)
  end

  # Query the system for objects that are direct instances of the
  # given class.
  # @param [Class]
  # @return [Array<ObjectMirror>] a list of appropriate mirrors for the requested objects
  def instances_of(klass)
    mirrors(ObjectSpace.each_object(klass).select { |obj| obj.class == klass })
  end

  # Ask the system to find the object with the given object id
  # @param [Numeric] object id
  # @return [ObjectMirror, NilClass] the object mirror or nil
  def object_by_id(id)
    obj = ObjectSpace._id2ref(id)
    obj ? reflect(obj) : nil
  end

  # Query the system for implementors of a particular message
  # @param [String] the message name
  # @return [Array<MethodMirror>] the implementing methods
  def implementations_of(str)
    methods = ObjectSpace.each_object(Module).collect do |m|
      ims = m.instance_methods(false).collect { |s| m.instance_method(s) }
      cms = m.methods(false).collect { |s| m.method(s) }
      ims + cms
    end.flatten

    mirrors(methods.select { |m| m.name.to_s == str.to_s })
  end

  # Create a mirror for a given object in the system under
  # observation.
  # @param [Object]
  # @return [Mirror]
  def reflect(o)
    Mirror.reflect(o)
  end

  private

  def mirrors(list)
    list.map { |e| reflect(e) }
  end
end
