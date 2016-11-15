require 'test_helper'

module LookingGlass
  class ObjectMirrorTest < MiniTest::Test
    def setup
      @o = ObjectFixture.new
      @m = LookingGlass.reflect(@o)
      super
    end

    def test_variables
      vars = @m.variables
      assert_equal(["@ivar"], vars.map(&:name))
    end
  end
end
