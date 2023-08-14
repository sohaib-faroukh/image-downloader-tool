require 'down'
require 'open-uri'
require 'concurrent'
require 'fileutils'
require 'net/http'

class DownloadImagesService
  MAX_CONCURRENT_THREADS = ENV.fetch('MAX_CONCURRENT_THREADS', 5).to_i
  MAX_ALLOWED_IMAGE_SIZE = ENV.fetch('MAX_ALLOWED_IMAGE_SIZE', 20_971_520).to_i # 20MB
  IMAGE_URLS_DELIMETER_REGEX = Regexp.new(
    ENV.fetch('IMAGE_URLS_DELIMETER_REGEX', '/[,;\s]+/')
  ).freeze

  def resolve_path(path:)
    File.join(ROOT_PATH, path) || ''
  end

  def file_exists?(file_path:)
    (File.exist?(file_path) && !File.directory?(file_path))
  end

  def mkdir(dir_path:)
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  end

  def download_images_from_text_file(text_file_path:, images_local_storage_path:)
    urls = extract_urls_from_text_file(:text_file_path => text_file_path)

    valid_image_urls_result = validate_image_urls(:urls => urls) do |invalid_url|
      LoggerUtil.error("Invalid image urls are detected: #{invalid_url}") unless invalid_url.blank?
    end

    valid_image_urls = valid_image_urls_result[:valid_urls] || []
    thread_pool = create_thread_pool

    valid_image_urls.each_with_index do |url, index|
      # Current time as part of file name to not conflict with other file names
      filename = "image_#{index + 1}_#{Time.now.to_i}.jpg"
      save_path = File.join(images_local_storage_path, filename)
      LoggerUtil.info "Saving to path: #{save_path}"

      thread_pool.post do
        download_image(:image_url => url, :image_save_path => save_path)
        LoggerUtil.info "Downloaded #{url} to #{save_path}"
      end
    end

    thread_pool.shutdown
    thread_pool.wait_for_termination
  end

  private

  def extract_urls_from_text_file(text_file_path:)
    image_urls = File.read(text_file_path).split(IMAGE_URLS_DELIMETER_REGEX)
    # Remove empty strings from the array
    image_urls.reject!(&:empty?)

    LoggerUtil.info "Image urls:\n\n#{image_urls&.join("\n")} \n\n"

    image_urls || []
  end

  def create_thread_pool(number_of_threads: nil)
    number_of_threads = MAX_ALLOWED_IMAGE_SIZE if number_of_threads.nil? || number_of_threads > MAX_ALLOWED_IMAGE_SIZE

    # Regardless, how many threads I am creating, the thread pool will only run number_of_threads threads at the same time
    Concurrent::FixedThreadPool.new(number_of_threads) # Number of concurrent threads
  end

  def validate_image_urls(urls:)
    valid_urls = []
    invalid_urls = []

    urls.each do |url|
      if valid_image_url?(:url => url)
        valid_urls << url
      else
        invalid_urls << url
        yield(url) if block_given?
      end
    end

    { :valid_urls => valid_urls, :invalid_urls => invalid_urls }
  end

  def valid_image_url?(url:)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    content_type = response['content-type']
    return false if content_type.nil?

    content_type.start_with?('image/')
  end

  def download_image(image_url:, image_save_path:)
    Down.download(
      image_url,
      :destination => image_save_path,
      :max_size => MAX_ALLOWED_IMAGE_SIZE,
      :max_redirects => 5
    )
  rescue StandardError => e
    LoggerUtil.error e
    puts e.backtrace
  end
end
