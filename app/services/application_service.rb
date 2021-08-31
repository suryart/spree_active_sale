class ApplicationService
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def self.call(*args)
    new(*args).call
  end
end
