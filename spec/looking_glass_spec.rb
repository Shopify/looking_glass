require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/reflect_spec'

describe LookingGlass do
  describe "queries" do
    it "finds known modules" do
      modules = LookingGlass.modules.collect(&:name)
      modules.should include("ReflectModule")
      modules.should_not include("ReflectClass")
    end

    it "finds known classes" do
      classes = LookingGlass.classes.collect(&:name)
      classes.should include("ReflectClass")
      classes.should_not include("ReflectModule")
    end

    it "finds known instances of something" do
      class MyObj; end
      class My2Obj < MyObj; end
      a = MyObj.new
      b = My2Obj.new
      instances = LookingGlass.instances_of(MyObj).collect(&:name)
      instances.should include(a.inspect)
      instances.should_not include(b.inspect)
    end

    it "can get vm objects id" do
      o = Object.new
      LookingGlass.object_by_id(o.object_id).name.should == o.inspect
    end

    it "can find implementors of a method" do
      l = LookingGlass.implementations_of("unique_reflect_fixture_method")
      l.should be_kind_of Array
      l.size.should == 1
      l.first.selector.should == "unique_reflect_fixture_method"
      l.first.defining_class.name.should == "ReflectClass"
    end
  end
end
