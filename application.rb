class Application
  require_relative 'app/errors/init'
  require_relative 'app/utils/init'
  require_relative 'app/controllers/init'
  require_relative 'root_path'

  def self.start(args:)
    LoggerUtil.info('Starting...')
    LoggerUtil.info("Args: #{args}")

    raise StandardError, "No provided arguments, #{args.names} argument can be provided." unless args&.to_a&.length&.positive?

    text_file_path = args[0]
    images_local_storage_path = args[1] || nil

    download_images_controller = DownloadImagesController.new
    download_images_controller.download_images_from_text_file(
      :text_file_path => text_file_path,
      :images_local_storage_path => images_local_storage_path
    )
  rescue StandardError => e
    LoggerUtil.error(e)
  end
end
