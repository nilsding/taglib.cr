module TagLib
  module FLAC
    class Picture
      # This describes the function or content of the picture.
      enum Type
        # A type not enumerated below.
        Other = 0x00
        # 32x32 PNG image that should be used as the file icon
        FileIcon = 0x01
        # File icon of a different size or format.
        OtherFileIcon = 0x02
        # Front cover image of the album.
        FrontCover = 0x03
        # Back cover image of the album.
        BackCover = 0x04
        # Inside leaflet page of the album.
        LeafletPage = 0x05
        # Image from the album itself.
        Media = 0x06
        # Picture of the lead artist or soloist.
        LeadArtist = 0x07
        # Picture of the artist or performer.
        Artist = 0x08
        # Picture of the conductor.
        Conductor = 0x09
        # Picture of the band or orchestra.
        Band = 0x0A
        # Picture of the composer.
        Composer = 0x0B
        # Picture of the lyricist or text writer.
        Lyricist = 0x0C
        # Picture of the recording location or studio.
        RecordingLocation = 0x0D
        # Picture of the artists during recording.
        DuringRecording = 0x0E
        # Picture of the artists during performance.
        DuringPerformance = 0x0F
        # Picture from a movie or video related to the track.
        MovieScreenCapture = 0x10
        # Picture of a large, coloured fish.
        ColouredFish = 0x11
        # Illustration related to the track.
        Illustration = 0x12
        # Logo of the band or performer.
        BandLogo = 0x13
        # Logo of the publisher (record company)
        PublisherLogo = 0x14
      end

      # Returns the type of the image.
      getter type
      # Returns the mime type of the image. This should in most cases be
      # "image/png" or "image/jpeg".
      getter mime_type
      # Returns a text description of the image.
      getter description
      # Returns the width of the image.
      getter width
      # Returns the height of the image.
      getter height
      # Returns the color depth (in bits-per-pixel) of the image.
      getter color_depth
      # Returns the number of colors used on the image (for indexed images).
      getter num_colors
      # Returns the image data.
      getter data : Slice(UInt8)

      # :nodoc:
      def initialize(@ptr : CrTagLib::FLACPicture)
        @type = Type.from_value(CrTagLib.flac_picture_type(ptr))
        @mime_type = TagLib.convert_string(CrTagLib.flac_picture_mime_type(ptr))
        @description = TagLib.convert_string(CrTagLib.flac_picture_description(ptr))
        @width = CrTagLib.flac_picture_width(ptr)
        @height = CrTagLib.flac_picture_height(ptr)
        @color_depth = CrTagLib.flac_picture_color_depth(ptr)
        @num_colors = CrTagLib.flac_picture_num_colors(ptr)
        @data = load_data
      end

      private def load_data : Slice(UInt8)
        data_ptr = CrTagLib.flac_picture_data(@ptr)
        slice = Slice(UInt8).new(data_ptr.value.data, data_ptr.value.length, read_only: true).dup
        CrTagLib.free_str(data_ptr, false)
        slice
      end

      # :nodoc:
      def inspect(io : IO) : Nil
        # lifted from: crystal//src/reference.cr

        io << "#<" << {{@type.name.id.stringify}} << ":0x"
        object_id.to_s(16, io)

        executed = exec_recursive(:inspect) do
          {% for ivar, i in @type.instance_vars %}
            {% if i > 0 %}
              io << ','
            {% end %}
              io << " @{{ivar.id}}="
            {% if ivar.id == "data" %}
              io << "{#{@{{ivar.id}}.size} bytes}"
            {% else %}
              @{{ivar.id}}.inspect io
            {% end %}
          {% end %}
        end
        unless executed
          io << " ..."
        end
        io << '>'
      end

      # :nodoc:
      def pretty_print(pp) : Nil
        # lifted from: crystal//src/reference.cr

        prefix = "#<#{{{@type.name.id.stringify}}}:0x#{object_id.to_s(16)}"
        executed = exec_recursive(:pretty_print) do
          pp.surround(prefix, ">", left_break: nil, right_break: nil) do
            {% for ivar, i in @type.instance_vars.map(&.name).sort %}
              {% if i == 0 %}
                pp.breakable
              {% else %}
                pp.comma
              {% end %}
                pp.group do
                pp.text "@{{ivar.id}}="
                pp.nest do
                  pp.breakable ""
                  {% if ivar.id == "data" %}
                    pp.text "{#{@{{ivar.id}}.size} bytes}"
                  {% else %}
                  @{{ivar.id}}.pretty_print(pp)
                  {% end %}
                end
              end
            {% end %}
          end
        end
        unless executed
          pp.text "#{prefix} ...>"
        end
      end
    end
  end
end
