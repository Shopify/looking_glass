require 'looking_glass/mirror'
require 'looking_glass/package_inference'

module LookingGlass
  class PackageMirror < Mirror
    reflect!(String)

    def name
      @subject.sub(/.*:/, '')
    end

    def fullname
      @subject
    end

    def children
      names = PackageInference.contents_of_package(@subject)
      classes = (names || [])
        .map { |n| Object.const_get(n) }
        .select { |c| c.is_a?(Module) }
        .sort_by(&:name)
      class_mirrors = mirrors(classes)

      # .map    { |pkg| pkg.sub(/#{Regexp.quote(@subject)}:.*?:.*/) }
      subpackages = PackageInference.qualified_packages
        .select { |pkg| pkg.start_with?("#{@subject}:") }
        .sort


      puts subpackages.inspect

      package_mirrors = subpackages.map { |pkg| PackageMirror.reflect(pkg) }
      package_mirrors.concat(class_mirrors)
    end
  end
end
