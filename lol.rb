$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'looking_glass/graph'
require 'looking_glass/graph/server'

module LookingGlass
  module Graph
    module IDGen
      def self.obj2id(object)
        case object
        when Viewer
          'v'
        when ClassMirror
          "c#{object.subject_id}"
        when MethodMirror
          klass_id = object.defining_class.subject_id
          "m#{klass_id}##{object.name}"
        when FieldMirror
          "c#{object.subject_id}" # TODO: GC will break this.
        else
          raise "unexpected object type: #{object.inspect}"
        end
      end

      def self.id2obj(id)
        puts "\x1b[34mloading id: #{id}\x1b[0m"
        case id[0]
        when 'v'
          Viewer.new
        when '-' # just wants empty result, usually '-1'
          return nil
        when 'c' # class
          obj = ObjectSpace._id2ref(id[1..-1].to_i)
          obj ? LookingGlass.reflect(obj) : nil
        when 'm' # method
          parts = id[1..-1].split('#')
          obj = ObjectSpace._id2ref(parts[0].to_i)
          mirror = obj ? LookingGlass.reflect(obj) : nil
          mirror.method(parts[1])
        else
          raise "unexpected id type: #{id}"
        end
      end

      def self.resolve(object)
        return ViewerType if object == Viewer
        case object
        when Viewer
          ViewerType
        when ClassMirror
          ClassType
        when MethodMirror
          MethodType
        when FieldMirror
          FieldType
        else
          raise "unexpected type: #{object.inspect}"
        end
      end
    end

    class Viewer
      def classes
        Object
          .constants
          .map { |name| Object.const_get(name) }
          .select { |const| const.is_a?(Module) } # class inherits Module
          .map { |mod| LookingGlass.reflect(mod) }
          .sort_by(&:name)
      end
    end

    ViewerType = GraphQL::ObjectType.define do
      name 'Viewer'
      interfaces [GraphQL::Relay::Node.interface]
      global_id_field :id

      field :classes, types[ClassType]

      field :class_detail do
        type ClassType
        argument :id, !types.ID
        resolve ->(_, args, _) do
          IDGen.id2obj(args[:id])
        end
      end

      field :method_detail do
        type MethodType
        argument :id, !types.ID
        resolve ->(_, args, _) do
          IDGen.id2obj(args[:id])
        end
      end
    end

    QueryType = GraphQL::ObjectType.define do
      name "Query"

      field(:node, GraphQL::Relay::Node.field)

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
      resolve_type ->(object, _ctx) { IDGen.resolve(object) }
      id_from_object ->(object, _type_definition, _query_ctx) { IDGen.obj2id(object) }
      object_from_id ->(id, _query_ctx) { IDGen.id2obj(id) }
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
