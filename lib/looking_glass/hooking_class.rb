module LookingGlass
  CLASS_DEFINITION_POINTS = {}
  MODULE_INSPECT = Module.method(:inspect).unbind

  module HookingClass
    class << self
      attr_reader :project_root
      def apply(project_root)
        @project_root = project_root

        Class.class_eval do
          alias_method :old_inherited, :inherited
          def inherited(subclass)
            file = caller[0].sub(/:\d+:in.*/, '')
            key = MODULE_INSPECT.bind(subclass).call
            LookingGlass::CLASS_DEFINITION_POINTS[key] = file
            old_inherited(subclass)
          end
        end
      end
    end
  end
end
