require_relative "base_error"
module Error
  class EmptyFile < BaseError

    def initialize
      @status = 400
      @message = "Empty file"
    end

  end # END class
end