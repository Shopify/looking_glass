module LookingGlass
  @unbound_module_methods = {}
  def self.module_invoke(receiver, msg)
    meth = (@unbound_module_methods[msg] ||= Module.instance_method(msg))
    meth.bind(receiver).call
  end
end

