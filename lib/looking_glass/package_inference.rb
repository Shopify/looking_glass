require 'rbconfig'

require 'looking_glass/hooking_class'

module LookingGlass
  module PackageInference
    extend self

    def infer_from(filename)
      return nil if filename.nil?

      if filename.starts_with?(HookingClass.project_root)
        return 'application'
      end

      return 'stdlib' if filename.starts_with?(rubylibdir)

      if defined?(Gem)
        Gem.path.each do |gp|
          path = "#{gp}/gems/"
          next unless filename.starts_with?(path)
          # extract e.g. 'bundler-1.13.6'
          gem_with_version = filename[path.size..-1].sub(/\/.*/, '')
          if gem_with_version =~ /(.*)-(\d|[a-f0-9]+$)/
            return $1
          end
        end
      end

      if defined?(Bundler)
        path = "#{Bundler.bundle_path}/bundler/gems/"
        if filename.starts_with?(path)
          gem_with_version = filename[path.size..-1].sub(/\/.*/, '')
          if gem_with_version =~ /(.*)-(\d|[a-f0-9]+$)/
            return $1
          end
        end
      end

      if filename == '(eval)'
        return nil
      end

      nil
    end

    def rubylibdir
      RbConfig::CONFIG['rubylibdir']
    end
  end
end
