require 'graphql'
require 'looking_glass/graph/class_type'

module LookingGlass
  module Graph
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
