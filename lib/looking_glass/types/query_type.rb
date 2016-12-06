module LookingGlass
  module Types
    QueryType = GraphQL::ObjectType.define do
      name "Query"

      field(:node, GraphQL::Relay::Node.field)

      field(:viewer) do
        type ViewerType
        resolve ->(_, _, _) { Viewer.new }
      end
    end
  end
end
