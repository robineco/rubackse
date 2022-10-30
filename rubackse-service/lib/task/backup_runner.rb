require 'rubygems'
require 'zip'

class BackupRunner

  def initialize(source_path, destination_path)
    @source_path = source_path
    @destination_path = destination_path
    @backups = []
  end

  def start_backup
    Dir.each_child(@source_path) do |entry|
      to_backup = File.join(@source_path, entry)
      next if File.file?(to_backup)
      compress_dir(to_backup)
    end
    @backups
  end

  def compress_dir(directory)
    zip_name = "#{File.join(@destination_path, directory.split("/")[-1])}.zip"
    begin
      Zip::File.open(zip_name, Zip::File::CREATE) do |zip_file|
        Dir[ File.join(directory, "**", "**") ].each do |file|
          zip_file.add( file.sub( "#{directory}/", ""), file)
        end
      end
    rescue Zip::ZipEntryExistsError
      puts "File already exists, deleting it..."
      File.delete(zip_name)
      compress_dir(directory)
    else
      @backups << zip_name
    end
  end
end

backup = BackupRunner.new('/tmp/backup', '/tmp/done')

p backup.start_backup

