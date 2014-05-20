require 'tmpdir'
require 'zip'

class BasePackager
  VERSION = "0.0.1"

  EXCLUDE_FROM_BUILDPACK = [
      /\.git/,
      /\.gitignore/,
      /\.{1,2}$/,
      /^cf_spec\b/,
      /^log\b/,
      /^test\b/
  ]

  def initialize(language, mode)
    @language = language
    @mode = mode
  end

  def package
    Dir.mktmpdir do |temp_dir|
      copy_buildpack_contents(temp_dir)
      download_dependencies(temp_dir) if mode == :offline
      compress_buildpack(temp_dir)
    end
  end

  def dependencies
    raise NotImplementedError
  end

  def excluded_files
    raise NotImplementedError
  end

  private

  attr_reader :mode, :language

  def copy_buildpack_contents(target_path)
    run_cmd "cp -r * #{target_path}"
  end

  def download_dependencies(target_path)
    dependency_path = File.join(target_path, 'dependencies')

    run_cmd "mkdir -p #{dependency_path}"

    dependencies.each do |uri|
      run_cmd "cd #{dependency_path}; curl #{uri} -O -L"
    end
  end

  def all_excluded_files
    @all_excluded_files ||= (EXCLUDE_FROM_BUILDPACK + excluded_files).uniq
  end

  def in_pack?(file)
    !all_excluded_files.any? { |re| file =~ re }
  end

  def run_cmd(cmd)
    puts "$ #{cmd}"
    system "#{cmd}"
  end

  def compress_buildpack(target_path)
    Zip::File.open("#{language}_buildpack.zip", Zip::File::CREATE) do |zipfile|
      Dir[File.join(target_path, '**', '**')].each do |file_path|
        relative_file_path = file_path.sub(target_path + '/', '')
        zipfile.add(relative_file_path, file_path) if (in_pack?(relative_file_path))
      end
    end
  end
end
