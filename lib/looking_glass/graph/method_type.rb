require 'graphql'
require 'looking_glass/graph/field_type'

module LookingGlass
  module Graph
    MethodType = GraphQL::ObjectType.define do
      name 'Method'

      # Mirror
      field :name, !types.String
      # field :mirrors?(other)
      # field :reflectee

      # MethodMirror
      field :file,                !types.String
      field :line,                !types.Int
      field :selector,            !types.String
      field :defining_class, -> { !ClassType }
      field :block_argument,       FieldType
      field :splat_argument,       FieldType
      field :optional_arguments,   types[FieldType]
      field :required_arguments,   types[FieldType]
      field :arguments,           !types[FieldType]
      field :visibility,          !types.String
      # field :protected?
      # field :public?
      # field :private?
      field :source,               types.String
      field :native_code,          types.String
      field :bytecode,             types.String
    end
  end
end
