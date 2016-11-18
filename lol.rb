$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'looking_glass/graph'
require 'looking_glass/graph/server'

module LookingGlass
  module Graph
    class Viewer
      def id
        '1'
      end

      def classes
        Object
          .constants
          .map { |name| Object.const_get(name) }
          .select { |const| const.is_a?(Module) } # class inherits Module
          .map { |mod| LookingGlass.reflect(mod) }
      end
    end

    ViewerType = GraphQL::ObjectType.define do
      name 'Viewer'
      field :id, !types.ID
      field :classes, types[ClassType]
    end

    QueryType = GraphQL::ObjectType.define do
      name "Query"

      field(:viewer) do
        type ViewerType
        resolve ->(_, _, _) { Viewer.new }
      end

      field(:allClasses) do
        type types[ClassType]
        resolve ->(_, _, _) do
          Object
            .constants
            .map { |name| Object.const_get(name) }
            .select { |const| const.is_a?(Module) } # class inherits Module
            .map { |mod| LookingGlass.reflect(mod) }
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

if ARGV[0] == 'u'
  schema = LookingGlass::Graph::Schema.execute(GraphQL::Introspection::INTROSPECTION_QUERY)
  File.write('schema.json', JSON.dump(schema))
  puts 'schema.json updated'
else
  require 'rack'
  Rack::Handler::WEBrick.run(LookingGlass::Graph::Server.new)
end
