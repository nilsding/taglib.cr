# taglib.cr

Some spicy read-only (for now?) bindings to the C++ TagLib library.  There be
dragons.

Tested only on 64-bit architectures (amd64, aarch64).

## Installation

1. Install taglib on your system
2. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  taglib:
    github: nilsding/taglib.cr
```
3. Run `shards install`

## Usage

```crystal
require "taglib"

fileref = TagLib::FileRef.new("Hubba Hubba Zoot Zoot.ogg")

# Get basic tag info
tags = fileref.tag.not_nil!
puts tags.artist  # => Caramba
puts tags.album   # => Så svenskt!
puts tags.year    # => 2002

# Get additional tags
properties = fileref.file.not_nil!.properties
pp properties  # => {"ALBUM" => ["Så svenskt!"],
               #     "ARTIST" => ["Caramba"],
               #     "DATE" => ["2002-06-18"],
               #     "TITLE" => ["Hubba Hubba Zoot Zoot"],
               #     "TRACKNUMBER" => ["2"],
               #     "TRACKTOTAL" => ["20"]}

# Get the audio properties of the given file
audio_properties = fileref.audio_properties.not_nil!
puts audio_properties.sample_rate        # => 44100
puts audio_properties.length_in_seconds  # => 117
```

## Development

TODO: Write development instructions here

## Contributing

1. [Fork it](https://github.com/nilsding/taglib.cr/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Georg Gadinger](https://github.com/nilsding) - creator and maintainer
