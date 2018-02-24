module App
  module Exception
    class InvalidParameter < ArgumentError; end
    class InsufficientPrivilege < ArgumentError; end
  end
end