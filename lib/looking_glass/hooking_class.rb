module LookingGlass
  CLASS_DEFINITION_POINTS = {}

  @unbound_module_methods = {}
  def self.module_invoke(receiver, msg)
    meth = (@unbound_module_methods[msg] ||= Module.method(msg).unbind)
    meth.bind(receiver).call
  end

  module HookingClass
    class << self
      attr_reader :project_root
      def apply(project_root)
        @project_root = project_root
      end
    end
  end
end

class Class
  alias_method :__lg_orig_inherited, :inherited
  def inherited(subclass)
    file = caller[0].sub(/:\d+:in.*/, '')
    key = LookingGlass.module_invoke(subclass, :inspect)
    LookingGlass::CLASS_DEFINITION_POINTS[key] = file
    __lg_orig_inherited(subclass)
  end
end
