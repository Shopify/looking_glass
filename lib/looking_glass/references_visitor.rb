require 'looking_glass/iseq_visitor'

module LookingGlass
  # ReferencesVisitor examines opcodes and records references to
  # classes, methods, and fields
  class ReferencesVisitor < LookingGlass::ISeqVisitor

      attr_reader :method_refs, :class_refs, :field_refs

      def initialize
        super
        @method_refs = []
        @class_refs = []
        @field_refs = []
      end

protected

      def visit(bytecode)
        case bytecode.first
        when :getinstancevariable
            @field_refs << bytecode[1]
        when :getconstant
            @class_refs << bytecode.last
        when :opt_send_without_block
            @method_refs << bytecode[1][:mid]
        end
      end
    end
end
