require 'looking_glass/mirror'
require 'looking_glass/package_inference'

module LookingGlass
  class PackageMirror < Mirror
    reflect!(String)

    def name
      @subject
    end

    def top_level_classes
      names = PackageInference.contents_of_package(@subject)
      classes = names
        .map { |n| Object.const_get(n) }
        .select { |c| c.is_a?(Module) }
        .sort_by(&:name)
      mirrors(classes)
    end
  end
end
