module LookingGlass
  module Types
    ViewerType = GraphQL::ObjectType.define do
      name 'Viewer'
      interfaces [GraphQL::Relay::Node.interface]
      global_id_field :id

      field :packages do
        type types[PackageType]
        resolve ->(_, _, _) { Mirrors.packages }
      end

      field :classDetail do
        type ClassType
        argument :id, !types.ID
        resolve ->(_, args, _) { IDGen.id2obj(args[:id]) }
      end

      field :methodDetail do
        type MethodType
        argument :id, !types.ID
        resolve ->(_, args, _) { IDGen.id2obj(args[:id]) }
      end
    end
  end
end
