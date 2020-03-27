module TagLib
  # A basic interface to most common audio properties.
  class AudioProperties
    # Returns the most appropriate bit rate for the file in kb/s. For constant
    # bitrate formats this is simply the bitrate of the file. For variable
    # bitrate formats this is either the average or nominal bitrate.
    getter bitrate
    # Returns the number of audio channels.
    getter channels
    # Returns the length of the file in seconds.
    getter length
    # Returns the length of the file in milliseconds.
    getter length_in_milliseconds
    # Returns the length of the file in seconds. The length is rounded down to the nearest whole second.
    getter length_in_seconds
    # Returns the sample rate in Hz.
    getter sample_rate

    private getter audio_properties

    # :nodoc:
    def initialize(@audio_properties : CrTagLib::AudioProperties)
      raise ArgumentError.new("No audio properties were read") if @audio_properties.null?

      @bitrate = CrTagLib.audio_properties_bitrate(@audio_properties)
      @channels = CrTagLib.audio_properties_channels(@audio_properties)
      @length = CrTagLib.audio_properties_length(@audio_properties)
      @length_in_milliseconds = CrTagLib.audio_properties_length_in_milliseconds(@audio_properties)
      @length_in_seconds = CrTagLib.audio_properties_length_in_seconds(@audio_properties)
      @sample_rate = CrTagLib.audio_properties_sample_rate(@audio_properties)
    end
  end
end
