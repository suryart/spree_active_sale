module ActiveSale
  class BaseService
    attr_reader :attributes
    attr_accessor :context

    def initialize(attributes)
      @attributes = attributes
      @context = OpenStruct.new(success: true)
    end

    def self.call(*args)
      begin
        new(*args).call
      rescue StandardError => e
        context = OpenStruct.new(success: false)
        context.errors = [e.message]

        context
      end
    end
  end
end
