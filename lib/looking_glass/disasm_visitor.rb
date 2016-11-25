require 'looking_glass/iseq_visitor'

module LookingGlass
  # DisasmVisitor prints a disassembled version of the bytecodes
  # in a format similar to that used by the disasm() method.
  class DisasmVisitor < LookingGlass::ISeqVisitor
      def visit(bytecode)
        puts " #{'%03d' % @pc} #{bytecode}  (#{@line})"
      end
    end
end
