module LookingGlass
  # The basic mirror. This is the lib code. It is also the factory to
  # use for creating new mirrors on any kind of object. Its #reflect
  # class method will return an appropriate mirror for a given object,
  # provided one has been registered. The [ObjectMirror] class should
  # have been registered as the fallback case for any kind of object,
  # but that may depend on the specific API implementation.
  class Mirror
    module ClassMethods
      @@mirrors = []

      # Reflect on the passed object. This is the default factory for
      # creating new mirrors, and it will try and find the appropriate
      # mirror from the list of registered mirrors.
      #
      # @param [Object] the object to reflect upon. This need not be the
      #   actual object represented - it can itself be just a
      #   representation.  It is really up to the mirror to decide what to
      #   do with it
      # @param [LookingGlass] the instance of a LookingGlass this mirror was
      #   spawned in.
      def reflect(obj)
        target_mirror = nil
        @@mirrors.detect { |klass| target_mirror = klass.mirror_class(obj) }
        target_mirror.new(obj)
      end

      # Decides whether the given class can reflect on [obj]
      # @param [Object] the object to reflect upon
      # @return [true, false]
      def reflects?(obj)
        @reflected_modules.any? { |mod| obj.is_a?(mod) }
      end

      # A shortcut to define reflects? behavior.
      # @param [Module] the module whose instances this mirror reflects
      def reflect!(*modules)
        @reflected_modules = modules
        register_mirror self
      end

      # Some objects may be more useful with a specialized kind of
      # mirror. This method can be used to register new mirror
      # classes. If used within a module, each class that includes
      # that specific module is registered upon inclusion.
      #
      # @param [Module] The class or module to register
      #
      # @return [Mirror] returns self
      def register_mirror(klass)
        @@mirrors.unshift klass
        @@mirrors.uniq!
        self
      end

      # @param [Object] the object to reflect upon
      #
      # @return [Mirror, NilClass] the class to instantiate as mirror,
      #   using #new, or nil, if non is known
      def mirror_class(obj)
        self if reflects?(obj)
      end
    end

    extend ClassMethods

    def initialize(obj)
      @subject = obj
    end

    def subject_id
      @subject.__id__.to_s
    end

    # A generic representation of the object under observation.
    def name
      @subject.inspect
    end

    # The equivalent to #==/#eql? for comparison of mirrors against objects
    def mirrors?(other)
      @subject == other
    end

    # Accessor to the reflected object
    def reflectee
      @subject
    end

    private

    def mirrors(list)
      list.collect { |e| LookingGlass.reflect(e) }
    end
  end
end
