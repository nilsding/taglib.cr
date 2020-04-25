module TagLib
  class File
    # Returns all the tags of the file.
    getter properties
    private getter file

    # :nodoc:
    def initialize(@file : CrTagLib::File)
      raise ArgumentError.new("not a valid file") if @file.null?

      @properties = {} of String => Array(String)
      read_file_properties
    end

    private def read_file_properties
      strlist = CrTagLib.file_properties(@file)

      current = strlist
      until current.value.next_ptr.null?
        key = String.new(current.value.str.value.data, current.value.str.value.length)

        raise "uneven stringlist!  expected a pair!" if current.value.next_ptr.null?
        current = current.value.next_ptr
        value = String.new(current.value.str.value.data, current.value.str.value.length)

        (@properties[key] ||= [] of String) << value

        current = current.value.next_ptr
      end

      CrTagLib.free_str_list(strlist)
    end
  end
end
