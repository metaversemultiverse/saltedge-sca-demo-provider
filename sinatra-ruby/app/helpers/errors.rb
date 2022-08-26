#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class BadRequest < StandardError; end
class WrongRequestFormat < BadRequest; end

class ConnectionNotFound < StandardError; end
class ActionNotFound < StandardError; end
class ActionClosed < StandardError; end
class ConsentNotFound < StandardError; end
