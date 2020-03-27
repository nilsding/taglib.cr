module TagLib
  # A basic interface to most common tags.
  class Tag
    # Returns the title.  If no title is present, an empty string will be returned.
    getter title
    # Returns the artist.  If no artist is present, an empty string will be returned.
    getter artist
    # Returns the album.  If no album is present, an empty string will be returned.
    getter album
    # Returns the comment.  If no comment is present, an empty string will be returned.
    getter comment
    # Returns the genre.  If no genre is present, an empty string will be returned.
    getter genre
    # Returns the year.  If there is no year set, this will return `0`.
    getter year
    # Returns the track number.  If there is no track number set, this will return `0`.
    getter track
    private getter tag, isempty

    # :nodoc:
    def initialize(@tag : CrTagLib::Tag)
      tmp_str = CrTagLib.tag_title(@tag)
      @title = String.new(tmp_str.value.data, tmp_str.value.length)
      CrTagLib.free_str(tmp_str)

      tmp_str = CrTagLib.tag_artist(@tag)
      @artist = String.new(tmp_str.value.data, tmp_str.value.length)
      CrTagLib.free_str(tmp_str)

      tmp_str = CrTagLib.tag_album(@tag)
      @album = String.new(tmp_str.value.data, tmp_str.value.length)
      CrTagLib.free_str(tmp_str)

      tmp_str = CrTagLib.tag_comment(@tag)
      @comment = String.new(tmp_str.value.data, tmp_str.value.length)
      CrTagLib.free_str(tmp_str)

      tmp_str = CrTagLib.tag_genre(@tag)
      @genre = String.new(tmp_str.value.data, tmp_str.value.length)
      CrTagLib.free_str(tmp_str)

      @year = CrTagLib.tag_year(@tag)
      @track = CrTagLib.tag_track(@tag)
      @isempty = CrTagLib.tag_is_empty(@tag)
    end

    # Returns `true` if the tag contains no data.
    def empty?
      @isempty
    end
  end
end
