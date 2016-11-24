require 'graphql'
require 'looking_glass/graph/field_type'
require 'looking_glass/graph/method_type'

module LookingGlass
  module Graph
    ClassType = GraphQL::ObjectType.define do
      name 'Class'

      interfaces [GraphQL::Relay::Node.interface]
      global_id_field :id

      # Mirror
      field :name, !types.String
      # field :mirrors?(other)
      # field :reflectee

      # ObjectMirror
      field :variables,    !types[FieldType]
      field :targetClass,  -> { !ClassType }, property: :target_class

      # ClassMirror
      field :package,                 types.String
      field :isClass,                !types.Boolean,        property: :is_class
      field :demodulizedName,        !types.String,         property: :demodulized_name
      field :classVariables,         !types[FieldType],     property: :class_variables
      field :classInstanceVariables, !types[FieldType],     property: :class_instance_variables
      field :sourceFiles,            !types[!types.String], property: :source_files
      field :singletonClass,    -> { !ClassType },          property: :singleton_class
      field :isSingletonClass,       !types.Boolean,        property: :is_singleton_class
      field :mixins,            -> { !types[ClassType] }
      field :superclass,        -> {  ClassType }
      field :subclasses,        -> { !types[ClassType] }
      field :ancestors,         -> { !types[ClassType] }
      field :constants,              !types[FieldType]
      # field :constant(str)
      field :nesting,           -> { !types[ClassType] }
      field :nestedClasses,     -> { !types[ClassType] },   property: :nested_classes
      field :nestedClassCount,       !types.Int,            property: :nested_class_count
      field :methods,                !types[MethodType]
      # field :method(name)
    end
  end
end
