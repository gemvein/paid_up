# PaidUp module
module PaidUp
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__))
  def self.version_string
    "PaidUp version #{PaidUp::VERSION}"
  end
end
