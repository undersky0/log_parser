require_relative "base_error"
module Error
  class PerformNotAllowed < BaseError

    def initialize
      @status = 400
      @message = "Bad request"
    end

  end # END class
end