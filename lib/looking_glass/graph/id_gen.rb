module LookingGlass
  module Graph
    module IDGen
      def self.obj2id(object)
        case object
        when Viewer
          'v'
        when PackageMirror
          "p#{object.instance_variable_get(:@subject)}"
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
        when 'p'
          PackageMirror.reflect(id[1..-1])
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
          Types::ViewerType
        when PackageMirror
          Types::PackageType
        when ClassMirror
          Types::ClassType
        when MethodMirror
          Types::MethodType
        when FieldMirror
          Types::FieldType
        else
          raise "unexpected type: #{object.inspect}"
        end
      end
    end
  end
end

