require "./spec_helper"

silence_file = File.expand_path("./fixtures/silence.flac", __DIR__)
untagged_file = File.expand_path("./fixtures/silence_untagged.flac", __DIR__)
invalid_file = File.expand_path("./fixtures/not_an_audio_file.txt", __DIR__)
mp3_file = File.expand_path("./fixtures/silence.mp3", __DIR__)
pictures_file = File.expand_path("./fixtures/silence_pictures.flac", __DIR__)

describe TagLib do
  it "can get the information from audio files" do
    fileref = TagLib::FileRef.new(silence_file)

    fileref.tag.should_not be_nil
    tag = fileref.tag.not_nil!
    tag.should_not be_empty
    tag.album.should eq "Some album"
    tag.artist.should eq "Some artist Another artist?  Oh my!"
    tag.comment.should eq "https://nilsding.org"
    tag.genre.should eq "Neue Deutsche Welle"
    tag.title.should eq "Some silence"
    tag.track.should eq 1
    tag.year.should eq 2020

    fileref.file.should_not be_nil
    properties = fileref.file.not_nil!.properties
    {"ALBUM"       => ["Some album"],
     "ARTIST"      => ["Some artist", "Another artist?  Oh my!"],
     "BPM"         => ["666"],
     "COMMENT"     => ["https://nilsding.org"],
     "DATE"        => ["2020-03-27"],
     "GENRE"       => ["Neue Deutsche Welle"],
     "LYRICS"      => ["There are no lyrics... only silence."],
     "MOOD"        => ["Big"],
     "TITLE"       => ["Some silence"],
     "TRACKNUMBER" => ["1"],
    }.each do |key, values|
      values.each do |value|
        properties[key].includes?(value).should eq true
      end
    end

    fileref.audio_properties.should_not be_nil
    audio_properties = fileref.audio_properties.not_nil!
    audio_properties.bitrate.should eq 1
    audio_properties.channels.should eq 1
    audio_properties.length.should eq 1
    audio_properties.length_in_milliseconds.should eq 1337
    audio_properties.length_in_seconds.should eq 1
    audio_properties.sample_rate.should eq 44100
  end

  it "handles untagged files" do
    fileref = TagLib::FileRef.new(untagged_file)

    fileref.tag.should_not be_nil
    tag = fileref.tag.not_nil!
    tag.should be_empty
    tag.album.should eq ""
    tag.artist.should eq ""
    tag.comment.should eq ""
    tag.genre.should eq ""
    tag.title.should eq ""
    tag.track.should eq 0
    tag.year.should eq 0

    fileref.file.should_not be_nil
    properties = fileref.file.not_nil!.properties
    properties.should eq({} of String => String)

    fileref.audio_properties.should_not be_nil
    audio_properties = fileref.audio_properties.not_nil!
    audio_properties.bitrate.should eq 1
    audio_properties.channels.should eq 1
    audio_properties.length.should eq 1
    audio_properties.length_in_milliseconds.should eq 1337
    audio_properties.length_in_seconds.should eq 1
    audio_properties.sample_rate.should eq 44100
  end

  it "handles invalid files" do
    fileref = TagLib::FileRef.new(invalid_file)
    fileref.file.should be_nil
    fileref.tag.should be_nil
    fileref.audio_properties.should be_nil
  end

  it "uses a concrete file class if one exists" do
    fileref = TagLib::FileRef.new(silence_file)
    fileref.file.should be_a(TagLib::FLAC::File)
    fileref = TagLib::FileRef.new(mp3_file)
    fileref.file.should be_a(TagLib::File)
  end

  it "loads pictures from FLAC files" do
    fileref = TagLib::FileRef.new(pictures_file)
    fileref.file.should be_a(TagLib::FLAC::File)

    flac_file = fileref.file.as(TagLib::FLAC::File)
    flac_file.pictures.size.should eq 3

    [
      {TagLib::FLAC::Picture::Type::FrontCover, "image/png",
       "yellow loudspeaker emitting rays", 32, 32, 4, 7, 497},
      {TagLib::FLAC::Picture::Type::ColouredFish, "image/png",
       "Xiph.org Foundation logo", 132, 126, 32, 0, 7933},
      {TagLib::FLAC::Picture::Type::LeadArtist, "image/jpeg",
       "das ist der Hackerblick™!", 256, 256, 24, 0, 47887},
    ].each_with_index do |(type, mime_type, description, width, height, color_depth, num_colors, byte_size), i|
      flac_file.pictures[i].type.should eq type
      flac_file.pictures[i].mime_type.should eq mime_type
      flac_file.pictures[i].description.should eq description
      flac_file.pictures[i].width.should eq width
      flac_file.pictures[i].height.should eq height
      flac_file.pictures[i].color_depth.should eq color_depth
      flac_file.pictures[i].num_colors.should eq num_colors
      flac_file.pictures[i].data.size.should eq byte_size
    end
  end
end
