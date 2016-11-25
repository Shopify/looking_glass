# mixin, convenience operator for method reflection
# inspired by Smalltalk
class Class
  def >>(symbol)
    LookingGlass.reflect(method(symbol))
  end

  def reflect
    LookingGlass.reflect(self)
  end
end
