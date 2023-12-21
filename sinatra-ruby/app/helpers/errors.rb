class BadRequest < StandardError; end
class WrongRequestFormat < BadRequest; end

class ConnectionNotFound < StandardError; end
class ActionNotFound < StandardError; end
class ActionClosed < StandardError; end
class ConsentNotFound < StandardError; end
