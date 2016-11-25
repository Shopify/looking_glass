require 'test_helper'

module LookingGlass
  class PackageInferenceTest < MiniTest::Test
    def test_identifies_core_classses
      assert_equal('core', PackageInference.infer_from(Object))
      assert_equal('core', PackageInference.infer_from(Errno))
      assert_equal('core', PackageInference.infer_from(Errno::E2BIG))
    end

    def test_identifies_stdlib
      assert_equal('core:stdlib', PackageInference.infer_from(Gem))
      assert_equal('core:stdlib', PackageInference.infer_from(Gem::Version))
    end

    def test_identifies_gems
      assert_equal('gems:minitest', PackageInference.infer_from(MiniTest::Test))
    end

    def test_eval_is_unknown
      eval("module LookingGlass::PackageInferenceTest::EvalModule; end")
      assert_equal('unknown', PackageInference.infer_from(EvalModule))
    end
  end
end
