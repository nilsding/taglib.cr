# Interface to /ext/taglib_cr.cpp
#
# TagLib has dependencies on zlib, and stdc++ (obviously).  Link against those
# as well.
#
# :private:
@[Link("z")]
@[Link("stdc++")]
@[Link("tag")]
@[Link(ldflags: "#{__DIR__}/../../ext/taglib_cr.o")]
lib CrTagLib
  struct CrString
    data : UInt8*
    length : LibC::SizeT
  end

  struct StrList
    str : CrString*
    next_ptr : StrList*
  end

  struct PtrList
    ptr : Void*
    next_ptr : PtrList*
  end

  enum FileType
    Unknown    = -1
    MPEG       =  0
    Ogg_Vorbis
    FLAC
    MPC
    WavPack
    Ogg_Speex
    Ogg_Opus
    TrueAudio
    MP4
    ASF
    RIFF_AIFF
    RIFF_WAV
    APE
    Mod
    S3M
    IT
    XM
  end

  type FileRef = Void*
  type AudioProperties = Void*
  type File = Void*
  type Tag = Void*
  type FLACPicture = Void*

  fun fileref_new = cr_taglib_fileref_new(filename : UInt8*) : FileRef
  fun fileref_delete = cr_taglib_fileref_delete(fileref : FileRef)
  fun fileref_audio_properties = cr_taglib_fileref_audio_properties(fileref : FileRef) : AudioProperties
  fun fileref_file = cr_taglib_fileref_file(fileref : FileRef) : File
  fun fileref_tag = cr_taglib_fileref_tag(fileref : FileRef) : Tag

  fun audio_properties_bitrate = cr_taglib_audio_properties_bitrate(audio_properties : AudioProperties) : Int32
  fun audio_properties_channels = cr_taglib_audio_properties_channels(audio_properties : AudioProperties) : Int32
  fun audio_properties_length = cr_taglib_audio_properties_length(audio_properties : AudioProperties) : Int32
  fun audio_properties_length_in_milliseconds = cr_taglib_audio_properties_length_in_milliseconds(audio_properties : AudioProperties) : Int32
  fun audio_properties_length_in_seconds = cr_taglib_audio_properties_length_in_seconds(audio_properties : AudioProperties) : Int32
  fun audio_properties_sample_rate = cr_taglib_audio_properties_sample_rate(audio_properties : AudioProperties) : Int32

  fun file_class = cr_taglib_file_class(file : File) : FileType
  fun file_properties = cr_taglib_file_properties(file : File) : StrList*

  fun tag_title = cr_taglib_tag_title(tag : Tag) : CrString*
  fun tag_artist = cr_taglib_tag_artist(tag : Tag) : CrString*
  fun tag_album = cr_taglib_tag_album(tag : Tag) : CrString*
  fun tag_comment = cr_taglib_tag_comment(tag : Tag) : CrString*
  fun tag_genre = cr_taglib_tag_genre(tag : Tag) : CrString*
  fun tag_year = cr_taglib_tag_year(tag : Tag) : UInt32
  fun tag_track = cr_taglib_tag_track(tag : Tag) : UInt32
  fun tag_is_empty = cr_taglib_tag_is_empty(tag : Tag) : Bool

  fun flac_file_picture_list = cr_taglib_flac_file_picture_list(file : File) : PtrList*
  fun flac_picture_type = cr_taglib_flac_picture_type(flac_picture : FLACPicture) : Int32
  fun flac_picture_data = cr_taglib_flac_picture_data(flac_picture : FLACPicture) : CrString*
  fun flac_picture_mime_type = cr_taglib_flac_picture_mime_type(flac_picture : FLACPicture) : CrString*
  fun flac_picture_description = cr_taglib_flac_picture_description(flac_picture : FLACPicture) : CrString*
  fun flac_picture_width = cr_taglib_flac_picture_width(flac_picture : FLACPicture) : Int32
  fun flac_picture_height = cr_taglib_flac_picture_height(flac_picture : FLACPicture) : Int32
  fun flac_picture_color_depth = cr_taglib_flac_picture_color_depth(flac_picture : FLACPicture) : Int32
  fun flac_picture_num_colors = cr_taglib_flac_picture_num_colors(flac_picture : FLACPicture) : Int32

  fun free_str = cr_taglib_free_str(cr_str : CrString*, free_string : Bool)
  fun free_str_list = cr_taglib_free_str_list(str_list : StrList*)
  fun free_ptr_list = cr_taglib_free_ptr_list(ptr_list : PtrList*)
end

module TagLib
  # Converts a CrString* to a String, and frees the reference afterwards.
  # :nodoc:
  protected def self.convert_string(str : CrTagLib::CrString*) : String
    cr_str = String.new(str.value.data, str.value.length)
    CrTagLib.free_str(str, true)
    cr_str
  end
end
