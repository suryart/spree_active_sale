module SpreeActiveSale
  VERSION = '4.2.0'.freeze

  module_function

  # Returns the version of the currently loaded SpreeAwesomeSale as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION
  end
end
