require 'test_helper'

module LookingGlass
  class MethodMirrorTest < MiniTest::Test
    def setup
      @cm = LookingGlass.reflect(MethodSpecFixture)
      super
    end

    def test_source_location
      @f = MethodSpecFixture
      m = MethodSpecFixture.instance_method(:source_location)
      @m = LookingGlass.reflect(m)

      assert_equal(@f.new.source_location[0],      @m.file)
      assert_equal(@f.new.source_location[1] - 2,  @m.line)
      assert_equal(@f.new.source_location[2],      @m.selector)
      assert_equal(@f.new.source_location[3].name, @m.defining_class.name)
      assert_includes(@m.source, '[__FILE__, __LINE__, __method__.to_s, self.class]')
    end

    def test_arguments
      m = LookingGlass.reflect(method(:method_b))
      assert_equal(%w(a b bb args block), m.arguments)
      assert_equal("block",  m.block_argument)
      assert_equal(%w(a),    m.required_arguments)
      assert_equal(%w(b bb), m.optional_arguments)
      assert_equal('args',   m.splat_argument)
    end

    def test_public_method
      m = @cm.method(:method_p_public)
      assert(m.public?)
      refute(m.protected?)
      refute(m.private?)
    end

    def test_protected_method
      m = @cm.method(:method_p_protected)
      refute(m.public?)
      assert(m.protected?)
      refute(m.private?)
    end

    def test_private_method
      m = @cm.method(:method_p_private)
      refute(m.public?)
      refute(m.protected?)
      assert(m.private?)
    end

    def test_delete_method
      c = MethodSpecFixture
      m = LookingGlass.reflect(c.instance_method(:removeable_method))
      assert_includes(c.instance_methods(false).map(&:to_s), "removeable_method")
      m.delete
      refute_includes(c.instance_methods(false).map(&:to_s), "removeable_method")
    end

    private

    def method_b(a, b = 1, bb = 2, *args, &block)
      to_s
      super
    end
  end
end
