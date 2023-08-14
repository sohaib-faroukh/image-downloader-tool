class MissingFileError < StandardError
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
    message = "Missing file at this path: #{@file_path}"
    super(message)
  end
end
