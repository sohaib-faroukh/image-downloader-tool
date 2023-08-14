require_relative '../services/download_images_service'

class DownloadImagesController
  attr_reader :download_images_service

  def initialize
    @download_images_service = DownloadImagesService.new
  end

  def download_images_from_text_file(text_file_path:, images_local_storage_path: nil)
    # TODO: implementation goes here

    LoggerUtil.info('Done downloading the images.')
  rescue StandardError => e
    LoggerUtil.error("Failed downloading the images: #{e&.message}")
  end
end
