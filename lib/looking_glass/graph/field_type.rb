require 'graphql'

module LookingGlass
  module Graph
    FieldType = GraphQL::ObjectType.define do
      name 'Field'

      field :id, !types.ID

      # Mirror
      field :name, !types.String
      # field :mirrors?(other)
      # field :reflectee

      # MethodMirror
      # TODO ???
    end
  end
end
