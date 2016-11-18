$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'looking_glass/graph'
require 'looking_glass/graph/server'

module LookingGlass
  module Graph
    class Viewer
      def self.id
        __id__
      end

      def self.classes
        Object
          .constants
          .map { |name| Object.const_get(name) }
          .select { |const| const.is_a?(Module) } # class inherits Module
          .map { |mod| LookingGlass.reflect(mod) }
      end
    end

    ViewerType = GraphQL::ObjectType.define do
      name 'Viewer'
      interfaces [GraphQL::Relay::Node.interface]
      global_id_field :id

      field :classes, types[ClassType]

      field :method do
        type MethodType
        argument :id, !types.ID
        resolve ->(_, args, _) do
          id = args[:id].to_i
          return nil if id < 0
          obj = ObjectSpace._id2ref(id)
          return nil unless obj
          return obj if obj == Viewer
          LookingGlass.reflect(obj)
        end
      end
    end

    QueryType = GraphQL::ObjectType.define do
      name "Query"

      field(:node, GraphQL::Relay::Node.field)

      field(:viewer) do
        type ViewerType
        resolve ->(_, _, _) { Viewer }
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

      resolve_type ->(object, ctx) {
        return ViewerType if object == Viewer
        case object
        when ClassMirror
          ClassType
        when MethodMirror
          MethodType
        when FieldMirror
          FieldType
        else
          puts object.inspect
          raise 'wat'
        end
      }

      id_from_object ->(object, type_definition, query_ctx) {
        object.id
      }

      object_from_id ->(id, query_ctx) {
        obj = ObjectSpace._id2ref(id.to_i)
        obj == Viewer ? obj : LookingGlass.reflect(obj)
      }
    end
  end
end

if ARGV[0] == 'u'
  schema = LookingGlass::Graph::Schema.execute(GraphQL::Introspection::INTROSPECTION_QUERY)
  File.write('frontend/data/schema.json', JSON.dump(schema))
  puts 'schema.json updated'
else
  require 'rack'
  Rack::Handler::WEBrick.run(LookingGlass::Graph::Server.new)
end
