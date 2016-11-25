require 'graphql'
require 'looking_glass/graph/types/class_type'

module LookingGlass
  module Graph
    module Types
      PackageType = GraphQL::ObjectType.define do
        name 'Package'

        interfaces [GraphQL::Relay::Node.interface]
        global_id_field :id

        # Mirror
        field :name, !types.String
        # field :mirrors?(other)
        # field :reflectee

        # PackageMirror
        field :children, types[!PackageChildrenUnionType]
      end
    end
  end
end
