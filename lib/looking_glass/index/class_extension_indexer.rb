module LookingGlass
  class ClassExtensionIndexer
    def self.run
    all_classes = 0
    suspect_classes = []
    logger = LookingGlass.logger

    LookingGlass.classes.each do |klass|
        source_files = klass.source_files
        all_classes += 1
        next unless source_files.size > 1
        suspect_classes << klass
    end

    suspect_count = suspect_classes.size
    logger.info "#{suspect_classes.size} / #{all_classes} classes have multiple sources"
    suspect_classes.each_with_index do | suspect,suspect_index |
      logger.info "  suspect: #{suspect_index+1} / #{suspect_count} #{suspect.name}"

      histogram = Hash.new(0)
      suspect.methods.each do | method |
        histogram[method.file] +=1
      end
      histogram.sort {|a1,a2| a2[1]<=>a1[1]}.each do |k,v|
        logger.info "    #{k}:#{v}"
      end
    end
    nil
  end
  end
end
