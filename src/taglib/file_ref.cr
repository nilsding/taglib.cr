require "./audio_properties"
require "./file"
require "./tag"

module TagLib
  # This class allows to read basic tagging and audio properties from files,
  # without having to know what the file type is.
  class FileRef
    @audio_properties : AudioProperties? = nil
    @file : File? = nil
    @tag : Tag? = nil

    # Returns an instance to the `TagLib::File` represented by this class.
    getter file
    # Returns the audio properties of this file as an instance of
    # `TagLib::AudioProperties` if the file is valid.
    getter audio_properties
    # Returns an instance of `TagLib::Tag` which contains some commonly used
    # tags.
    getter tag

    def initialize(filename : String)
      @fileref = CrTagLib.fileref_new(filename.to_unsafe)

      file = CrTagLib.fileref_file(@fileref)
      unless file.null?
        file_type = CrTagLib.file_class(file)
        @file = file_class(file_type).new(file)
      end

      audio_props = CrTagLib.fileref_audio_properties(@fileref)
      @audio_properties = AudioProperties.new(audio_props) unless audio_props.null?

      tag = CrTagLib.fileref_tag(@fileref)
      @tag = Tag.new(tag) unless tag.null?
    end

    # :nodoc:
    def finalize
      CrTagLib.fileref_delete(@fileref)
    end

    private def file_class(file_type : CrTagLib::FileType)
      case file_type
      when .flac?
        FLAC::File
      else
        File
      end
    end
  end
end
