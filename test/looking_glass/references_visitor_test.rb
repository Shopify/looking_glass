require 'test_helper'
require 'looking_glass/disasm_visitor'

module LookingGlass
  class ReferencesVisitorTest < MiniTest::Test

    class Victim
      def lol
        @ivar += 1  # touch one of the ivars
        self.to_s   # send to_s
        Kernel.exit # reference another class
      end
    end 

    def test_victim_class
      victim = LookingGlass.classes.detect {|c| c.reflectee == Victim }
      method = victim.method(:lol)
      visitor = method.references_visitor

      assert_equal([:to_s, :exit], visitor.method_refs)
      assert_equal([:Kernel], visitor.class_refs)
      assert_equal([:@ivar], visitor.field_refs)      
    end
  end
end