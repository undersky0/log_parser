require_relative "../lib/error/perform_not_allowed"
module Services
  class BaseService
    attr_accessor :record

    # Handy class method that should only be used to do single tasks which either return an object or boolean.
    #   Ex: when you don't expect a result object do
    #         Services::SomeService.new(record, option).perform
    #   Ex: when you  expect a result object
    #         service_object = Services::SomeService.new(record, option)
    #         service_object.perform
    #         service_object.results
    # The service object is designed to raise an exception, for which you will need a method to cach them and respond appropriately
    # You will want to handle exceptions differently in the controllers/models/apis
    # Ex: when you want to only print and error
    #
    #         def exception_handler
    #           begin
    #             yield
    #           rescue Error::PerformNotAllowed, Error::EmptyFile => e
    #             puts e.message, e.status
    #           end
    #         end
    #
    #         exception_handler do
    #           service_object = Services::SomeService.new(record, options)
    #           service_object.perform
    #           service_object.results
    #         end

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(record, options = {})
      @record  = record
      @options = options

      @performed = false
    end

    def perform
      if allow?
        perform_if_allowed
      else
        raise Error::PerformNotAllowed
      end
      @performed = true
    end

    def performed?
      @performed
    end

  end # END class
end