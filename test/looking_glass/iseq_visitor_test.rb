require 'test_helper'
require 'looking_glass/disasm_visitor'

module LookingGlass
  class ISeqVisitorTest < MiniTest::Test
    class CountingVisitor < LookingGlass::ISeqVisitor
      attr_reader :count
      def initialize
        @count = 0
      end

      def visit(_bytecode)
        @count += 1
      end
    end

    def test_all_methods
      Kernel
      class_count = 0
      method_count = 0
      visitor = CountingVisitor.new
      LookingGlass.classes.each do |clazz|
        clazz.methods.each do |meth|
          visitor.call(meth)
          method_count += 1
        end
        class_count += 1
      end
      assert(class_count >= 788)
      assert(method_count >= 4782)
      assert(visitor.count >= 47308)

      puts "Walked #{class_count} classes with #{method_count} methods and #{visitor.count} bytecodes."
    end
  end
end
