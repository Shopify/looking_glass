require 'graphql'

module LookingGlass
  module Graph
    PackageChildrenUnionType = GraphQL::UnionType.define do
      name 'PackageChildren'
      possible_types [PackageType, ClassType]
    end
  end
end
