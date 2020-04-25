module TagLib
  module FLAC
    class File < TagLib::File
      @pictures = [] of FLAC::Picture

      # Returns a list of pictures attached to the FLAC file.
      getter pictures

      # :nodoc:
      def initialize(@file : CrTagLib::File)
        super

        load_pictures
      end

      private def load_pictures
        ptrlist = CrTagLib.flac_file_picture_list(@file)

        current = ptrlist
        until current.value.next_ptr.null?
          @pictures << Picture.new(current.value.ptr.as(CrTagLib::FLACPicture))

          current = current.value.next_ptr
        end

        CrTagLib.free_ptr_list(ptrlist)
      end
    end
  end
end
