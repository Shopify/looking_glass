require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/method_spec'

describe "MethodMirror" do
  describe "runtime reflection" do
    describe "structural queries" do
      before(:each) do
        @f = MethodSpecFixture
        m = MethodSpecFixture.instance_method(:source_location)
        @m = LookingGlass.reflect(m)
      end

      it "file" do
        @m.file.should == @f.new.source_location[0]
      end

      it "line" do
        @m.line.should == (@f.new.source_location[1] - 2)
      end

      it "selector" do
        @m.selector.should == @f.new.source_location[2]
      end

      it "defining class" do
        @m.defining_class.name.should == @f.new.source_location[3].name
      end

      it "source" do
        @m.source.should =~ /[__FILE__, __LINE__, __method__.to_s, self.class]/
      end
    end

    describe "runtime behavior queries" do
      def method_b(a, aa, b = 1, bb = 2, *args, &block)
        to_s
        super
      end

      before do
        @m = LookingGlass.reflect(method(:method_b))
      end

      describe "arguments" do
        it "argument list" do
          @m.arguments.should include("a", "aa", "b", "bb", "args", "block")
        end

        it "block argument" do
          @m.block_argument.should == "block"
        end

        it "required arguments" do
          @m.required_arguments.should include("a", "aa")
        end

        it "optional arguments" do
          @m.optional_arguments.should include("b", "bb")
        end

        it "splat argument" do
          @m.splat_argument.should == "args"
        end
      end

      describe "protection" do
        before do
          @cm = LookingGlass.reflect(MethodSpecFixture)
        end

        it "is public" do
          m = @cm.method(:method_p_public)
          m.public?.should.be_true
          m.protected?.should.be_false
          m.private?.should.be_false
        end

        it "is private" do
          m = @cm.method(:method_p_private)
          m.public?.should.be_false
          m.protected?.should.be_false
          m.private?.should.be_true
        end

        it "is protected" do
          m = @cm.method(:method_p_protected)
          m.public?.should.be_false
          m.protected?.should.be_true
          m.private?.should.be_false
        end
      end

      it "can delete a method from its home class" do
        c = MethodSpecFixture
        m = LookingGlass.reflect c.instance_method(:removeable_method)
        c.instance_methods(false).map(&:to_s).should include("removeable_method")
        m.delete
        c.instance_methods(false).map(&:to_s).should_not include("removeable_method")
      end
    end
  end
end
