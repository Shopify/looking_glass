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
      field :target_class, -> { !ClassType }

      # ClassMirror
      field :class_variables,          !types[FieldType]
      field :class_instance_variables, !types[FieldType]
      field :source_files,             !types[!types.String]
      field :singleton_class,     -> { !ClassType }
      field :is_singleton_class,       !types.Boolean
      field :mixins,              -> { !types[ClassType] }
      field :superclass,          -> {  ClassType }
      field :subclasses,          -> { !types[ClassType] }
      field :ancestors,           -> { !types[ClassType] }
      field :constants,                !types[FieldType]
      # field :constant(str)
      field :nesting,             -> { !types[ClassType] }
      field :nested_classes,      -> { !types[ClassType] }
      field :methods,                  !types[MethodType]
      # field :method(name)
    end
  end
end
