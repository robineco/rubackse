require 'dotenv'
require "google/cloud/storage"
require_relative '../logger/logger'

class GCloudUploader

  def initialize(source_diretory, bucket_directory, secret_file, env_file)
    @source_diretory = source_diretory
    @bucket_directory = bucket_directory
    @logger = Logger.new(source_name: 'GCloudUploader')

    unless File.exist?(secret_file)
      raise "Secret file does not exists"
    end
    if File.exist?(env_file)
      Dotenv.load(env_file)
      @project_id = ENV['GCLOUD_PROJECT_ID']
      @bucket_name = ENV['GCLOUD_BUCKET_NAME']

      if @project_id.nil? || @bucket_name.nil?
        @logger.error('project_id or bucket_name is missing')
        raise "Missing parameter in env file"
      end
      @gcloud = Google::Cloud.new(@project_id, secret_file)
    else
      @logger.error('Missing ENV file')
      raise "ENV file does not exists"
    end
  end

  def start_upload
    puts "source: #{@source_diretory}"
    Dir.each_child(@source_diretory) do |entry|
      to_upload = File.join(@source_diretory, entry)
      next if File.directory?(to_upload)
      upload_file(to_upload)
    end
  end

  def upload_file(file)
    file_name = File.basename(file)
    begin
      bucket = @gcloud.storage.bucket(@bucket_name)
      bucket.create_file(file, File.join(@bucket_directory ,file_name))
      puts "Uploaded file: #{file}"
      File.delete(file)
    rescue Error => e
      @logger.error('Something went wrong while uploading')
      @logger.error('e')
    end
  end

end

secret = '/Users/robin/Documents/Coding/Ruby/rubackse/config/secrets/prod.key.json'
env = '/Users/robin/Documents/Coding/Ruby/rubackse/config/secrets/.env'

uploader = GCloudUploader.new("/tmp/done", "backup-service", secret, env)
uploader.start_upload