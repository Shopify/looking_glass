module LookingGlass
  # A specific mirror for a class, that includes all the capabilites
  # and information we can gather about classes.
  class ClassMirror < ObjectMirror
    reflect!(Module)

    def is_class
      @subject.is_a?(Class)
    end

    def package
      # TODO(burke)
    end

    # The known class variables.
    # @see #instance_variables
    # @return [Array<FieldMirror>]
    def class_variables
      field_mirrors(@subject.class_variables)
    end

    # The known class variables.
    # @see #instance_variables
    # @return [Array<FieldMirror>]
    def class_instance_variables
      field_mirrors(@subject.instance_variables)
    end

    # The source files this class is defined and/or extended in.
    #
    # @return [Array<String,File>]
    def source_files
      locations = @subject.instance_methods(false).collect do |name|
        method = @subject.instance_method(name)
        sl = method.source_location
        sl.first if sl
      end
      locations.compact.uniq
    end

    # The singleton class of this class
    #
    # @return [ClassMirror]
    def singleton_class
      LookingGlass.reflect(@subject.singleton_class)
    end

    # Predicate to determine whether the subject is a singleton class
    #
    # @return [true,false]
    def singleton_class?
      name.match(/^\#<Class:.*>$/)
    end

    # The mixins included in the ancestors of this class.
    #
    # @return [Array<ClassMirror>]
    def mixins
      mirrors(@subject.ancestors.reject { |m| m.is_a?(Class) })
    end

    # The direct superclass
    #
    # @return [ClassMirror]
    def superclass
      LookingGlass.reflect(@subject.superclass)
    end

    # The known subclasses
    #
    # @return [Array<ClassMirror>]
    def subclasses
      mirrors(ObjectSpace.each_object(Class).select { |a| a.superclass == @subject })
    end

    # The list of ancestors
    #
    # @return [Array<ClassMirror>]
    def ancestors
      mirrors(@subject.ancestors)
    end

    # The constants defined within this class. This includes nested
    # classes and modules, but also all other kinds of constants.
    #
    # @return [Array<FieldMirror>]
    def constants
      field_mirrors(@subject.constants)
    end

    # Searches for the named constant in the mirrored namespace. May
    # include a colon (::) separated constant path. This _may_ trigger
    # an autoload!
    #
    # @return [ClassMirror, nil] the requested constant, or nil
    def constant(str)
      path = str.to_s.split("::")
      c = path[0..-2].inject(@subject) { |klass, s| klass.const_get(s) }
      field_mirror (c || @subject), path.last
    rescue NameError => e
      p e
      nil
    end

    # The full nesting.
    #
    # @return [Array<ClassMirror>]
    def nesting
      ary = []
      @subject.name.split('::').inject(Object) do |klass, str|
        ary << klass.const_get(str)
        ary.last
      end
      ary.reverse
    rescue NameError
      [@subject]
    end

    # The classes nested within the subject. Should _not_ trigger
    # autloads!
    #
    # @return [Array<ClassMirror>]
    def nested_classes
      nc = @subject.constants.collect do |c|
        # do not trigger autoloads
        if @subject.const_defined?(c) && !@subject.autoload?(c)
          @subject.const_get(c)
        end
      end
      mirrors(nc.compact.select { |c| c.is_a?(Module) }.sort_by(&:name))
    end

    def nested_class_count
      nested_classes.count
    end

    # The instance methods of this class. To get to the class methods,
    # ask the #singleton_class for its methods.
    #
    # @return [Array<MethodMirror>]
    def methods
      pub_names  = @subject.public_instance_methods(false)
      prot_names = @subject.protected_instance_methods(false)
      priv_names = @subject.private_instance_methods(false)

      mirrors = []
      pub_names.sort.each do |n|
        mirrors << LookingGlass.reflect(@subject.instance_method(n))
      end
      prot_names.sort.each do |n|
        mirrors << LookingGlass.reflect(@subject.instance_method(n))
      end
      priv_names.sort.each do |n|
        mirrors << LookingGlass.reflect(@subject.instance_method(n))
      end
      mirrors
    end

    # The instance method of this class or any of its superclasses
    # that has the specified selector
    #
    # @return [MethodMirror, nil] the method or nil, if none was found
    def method(name)
      LookingGlass.reflect @subject.instance_method(name)
    end

    # to work around overridden `name` methods
    MODULE_INSPECT = Module.instance_method(:inspect)
    def name
      MODULE_INSPECT.bind(@subject).call
    rescue
      puts @subject.inspect
      puts @subject.class
      raise
    end

    def demodulized_name
      name.split('::').last
    end
  end
end
