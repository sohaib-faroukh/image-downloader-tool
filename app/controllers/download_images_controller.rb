require_relative '../services/download_images_service'
class DownloadImagesController
  attr_reader :download_images_service

  def initialize
    @download_images_service = DownloadImagesService.new
  end

  def download_images_from_text_file(text_file_path:, images_local_storage_path: nil)
    default_images_local_storage_path = ENV.fetch('DEFAULT_IMAGES_LOCAL_STORAGE_PATH', nil)
    raise MissingEnvVariableError, 'DEFAULT_IMAGES_LOCAL_STORAGE_PATH' if default_images_local_storage_path.nil?

    resolved_text_file_path = @download_images_service.resolve_path(:path => text_file_path)

    # check if the given text file exists
    unless resolved_text_file_path && @download_images_service.file_exists?(:file_path => resolved_text_file_path)
      raise MissingFileError, resolved_text_file_path
    end

    # if storage file path is not provided, use default one (which defined in an environment variable)
    images_local_storage_path ||= default_images_local_storage_path
    resolved_images_local_storage_path = @download_images_service.resolve_path(:path => images_local_storage_path)

    # create images saving directory if doesn't exist
    @download_images_service.mkdir(:dir_path => resolved_images_local_storage_path)

    @download_images_service.download_images_from_text_file(
      :text_file_path => resolved_text_file_path,
      :images_local_storage_path => resolved_images_local_storage_path
    )

    LoggerUtil.info('Done downloading the images.')
  rescue StandardError => e
    LoggerUtil.error("Failed downloading the images: #{e&.message}")
  end
end
