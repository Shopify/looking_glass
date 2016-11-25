require 'graphql'

module LookingGlass
  module Graph
    module Types
      FieldType = GraphQL::ObjectType.define do
        name 'Field'

        interfaces [GraphQL::Relay::Node.interface]
        global_id_field :id

        # Mirror
        field :name, !types.String
        # field :mirrors?(other)
        # field :reflectee

        # MethodMirror
        # TODO ???
      end
    end
  end
end
