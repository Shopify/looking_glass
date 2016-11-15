require 'graphql'
require 'looking_glass'

QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :class do
    type ClassType
    argument :name, !types.String
    resolve ->(_, args, _) do
      LookingGlass.reflect(
        Kernel.const_get(args[:name])
      )
    end
  end
end

ClassType = GraphQL::ObjectType.define do
  name "Class"
  field :name,      types.String
  field :ancestors, -> { types[ClassType] }
end

Schema = GraphQL::Schema.define do
  query QueryType
end

query_string = '{ class(name: "Object") { name ancestors { name } }}'
result = Schema.execute(query_string)

puts result

