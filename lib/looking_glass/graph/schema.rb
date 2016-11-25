module LookingGlass
  module Graph
    Schema = GraphQL::Schema.define do
      query Types::QueryType
      resolve_type ->(object, _ctx) { IDGen.resolve(object) }
      id_from_object ->(object, _type_definition, _query_ctx) { IDGen.obj2id(object) }
      object_from_id ->(id, _query_ctx) { IDGen.id2obj(id) }
    end
  end
end
