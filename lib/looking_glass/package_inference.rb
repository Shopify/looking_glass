require 'rbconfig'
require 'set'

require 'looking_glass/hooking_class'

module LookingGlass
  module PackageInference
    extend self

    def infer_from(mod)
      infer_from_key(LookingGlass.module_invoke(mod, :inspect))
    end

    def infer_from_toplevel(sym)
      infer_from_key(sym.to_s)
    end

    def contents_of_package(pkg)
      @inverse_cache[pkg]
    end

    def qualified_packages
      @inverse_cache.keys
    end

    private

    def infer_from_key(key)
      @inference_cache ||= {}
      @inverse_cache ||= {}

      cached = @inference_cache[key]
      return cached if cached

      pkg = uncached_infer_from(key)
      @inference_cache[key] = pkg
      @inverse_cache[pkg] ||= []
      @inverse_cache[pkg] << key

      pkg
    end

    # ruby --disable-gems -e 'puts Object.constants'
    CORE = Set.new(%w(
      Object Module Class BasicObject Kernel NilClass NIL Data TrueClass TRUE
      FalseClass FALSE Encoding Comparable Enumerable String Symbol Exception
      SystemExit SignalException Interrupt StandardError TypeError
      ArgumentError IndexError KeyError RangeError ScriptError SyntaxError
      LoadError NotImplementedError NameError NoMethodError RuntimeError
      SecurityError NoMemoryError EncodingError SystemCallError Errno
      UncaughtThrowError ZeroDivisionError FloatDomainError Numeric Integer
      Fixnum Float Bignum Array Hash ENV Struct RegexpError Regexp MatchData
      Marshal Range IOError EOFError IO STDIN STDOUT STDERR ARGF FileTest File
      Dir Time Random Signal Proc LocalJumpError SystemStackError Method
      UnboundMethod Binding Math GC ObjectSpace Enumerator StopIteration
      RubyVM Thread TOPLEVEL_BINDING ThreadGroup ThreadError ClosedQueueError
      Mutex Queue SizedQueue ConditionVariable Process Fiber FiberError
      Rational Complex RUBY_VERSION RUBY_RELEASE_DATE RUBY_PLATFORM
      RUBY_PATCHLEVEL RUBY_REVISION RUBY_DESCRIPTION RUBY_COPYRIGHT
      RUBY_ENGINE RUBY_ENGINE_VERSION TracePoint ARGV DidYouMean
    )).freeze

    def uncached_infer_from(key, exclusions = [])
      filename = CLASS_DEFINITION_POINTS[key]

      if filename.nil?
        return 'core' if CORE.include?(key)
        return try_harder(key, exclusions) ############
      end

      if filename.start_with?(HookingClass.project_root)
        return 'application'
      end

      return 'core:stdlib' if filename.start_with?(rubylibdir)

      if defined?(Gem)
        gem_path.each do |path|
          next unless filename.start_with?(path)
          # extract e.g. 'bundler-1.13.6'
          gem_with_version = filename[path.size..-1].sub(%r{/.*}, '')
          if gem_with_version =~ /(.*)-(\d|[a-f0-9]+$)/
            return "gems:#$1"
          end
        end
      end

      if defined?(Bundler)
        path = bundle_path
        if filename.start_with?(path)
          gem_with_version = filename[path.size..-1].sub(%r{/.*}, '')
          if gem_with_version =~ /(.*)-(\d|[a-f0-9]+$)/
            return "gems:#$1"
          end
        end
      end

      if filename == '(eval)'
        return "unknown"
      end

      "unknown"
    end

    def try_harder(key, exclusions = [])
      obj = Object.const_get(key)
      return 'unknown' unless obj.is_a?(Module)
      exclusions << obj

      obj.constants.each do |const| ##############
        child = obj.const_get(const)
        next unless child.is_a?(Module)

        next if exclusions.include?(child)

        pkg = uncached_infer_from(LookingGlass.module_invoke(child, :inspect), exclusions)
        return pkg unless pkg == 'unknown'
      end

      return 'unknown'
    end

    def rubylibdir
      @rubylibdir ||= RbConfig::CONFIG['rubylibdir']
    end

    def gem_path
      @gem_path ||= Gem.path.map { |p| "#{p}/gems/" }
    end

    def bundle_path
      @bundle_path ||= "#{Bundler.bundle_path}/bundler/gems/"
    end
  end
end
