require 'graphql'
require 'looking_glass/graph/types/field_type'

module LookingGlass
  module Graph
    module Types
      MethodType = GraphQL::ObjectType.define do
        name 'Method'

        interfaces [GraphQL::Relay::Node.interface]
        global_id_field :id

        # Mirror
        field :name, !types.String
        # field :mirrors?(other)
        # field :reflectee

        # MethodMirror
        field :file,                 types.String
        field :line,                 types.Int
        field :selector,            !types.String
        field :definingClass,  -> { !ClassType },      property: :defining_class
        field :blockArgument,        FieldType,        property: :block_argument
        field :splatArgument,        FieldType,        property: :splat_argument
        field :optionalArguments,    types[FieldType], property: :optional_arguments
        field :requiredArguments,    types[FieldType], property: :required_arguments
        field :arguments,           !types[FieldType]
        field :visibility,          !types.String
        # field :protected?
        # field :public?
        # field :private?
        field :superMethod,     -> { MethodType },     property: :super_method
        field :comment,              types.String
        field :source,               types.String
        field :native_code,          types.String,     property: :native_code
        field :bytecode,             types.String
        field :sexp,                 types.String
      end
    end
  end
end
