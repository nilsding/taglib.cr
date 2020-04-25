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
      @title = TagLib.convert_string(CrTagLib.tag_title(@tag))
      @artist = TagLib.convert_string(CrTagLib.tag_artist(@tag))
      @album = TagLib.convert_string(CrTagLib.tag_album(@tag))
      @comment = TagLib.convert_string(CrTagLib.tag_comment(@tag))
      @genre = TagLib.convert_string(CrTagLib.tag_genre(@tag))

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
