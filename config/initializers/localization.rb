# Because the _ method is simply an extension to Object, you
# can use it anywhere (models/controllers/views/libs).
class Object

  def _(*args)
    I18n.t(*args)
  end

  def _l(*args)
    I18n.l(*args)
  end
end