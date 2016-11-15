require 'graphql'

module LookingGlass
  module Graph
    FieldType = GraphQL::ObjectType.define do
      name 'Field'

      # Mirror
      field :name, !types.String
      # field :mirrors?(other)
      # field :reflectee

      # MethodMirror
      # TODO ???
    end
  end
end
