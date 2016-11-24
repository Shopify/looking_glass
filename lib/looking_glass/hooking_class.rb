module LookingGlass
  CLASS_DEFINITION_POINTS = {}

  module HookingClass
    class << self
      attr_reader :project_root
      def apply(project_root)
        @project_root = project_root

        Class.class_eval do
          alias_method :old_inherited, :inherited
          def inherited(subclass)
            file = caller[0].sub(/:\d+:in.*/, '')
            LookingGlass::CLASS_DEFINITION_POINTS[subclass] = file
            old_inherited(subclass)
          end
        end
      end
    end
  end
end
