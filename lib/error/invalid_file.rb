require_relative "base_error"
module Error
  class InvalidFile < BaseError

    def initialize
      @status = 400
      @message = "Invalid File"
    end

  end # END class
end