$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'looking_glass/graph'
require 'looking_glass/graph/server'

module LookingGlass
  module Graph
    QueryType = GraphQL::ObjectType.define do
      name "Query"

      field(:allClasses) do
        type types[ClassType]
        resolve ->(_, _, _) do
          LookingGlass.classes
        end
      end

      field(:class) do
        type ClassType
        argument :name, !types.String
        resolve ->(_, args, _) do
          LookingGlass.reflect(
            Kernel.const_get(args[:name])
          )
        end
      end
    end

    Schema = GraphQL::Schema.define do
      query QueryType
    end
  end
end

require 'rack'
Rack::Handler::WEBrick.run(LookingGlass::Graph::Server.new)
