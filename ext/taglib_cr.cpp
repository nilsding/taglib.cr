#include <cstring>

#include <taglib/fileref.h>
#include <taglib/tpropertymap.h>

#include <taglib/aifffile.h>
#include <taglib/apefile.h>
#include <taglib/asffile.h>
#include <taglib/flacfile.h>
#include <taglib/itfile.h>
#include <taglib/modfile.h>
#include <taglib/mp4file.h>
#include <taglib/mpcfile.h>
#include <taglib/mpegfile.h>
#include <taglib/opusfile.h>
#include <taglib/s3mfile.h>
#include <taglib/speexfile.h>
#include <taglib/trueaudiofile.h>
#include <taglib/vorbisfile.h>
#include <taglib/wavfile.h>
#include <taglib/wavpackfile.h>
#include <taglib/xmfile.h>

extern "C"
{

    typedef struct cr_string
    {
        const char* data;
        size_t length;
    } cr_string_t;

    typedef struct str_list
    {
        cr_string_t* str;
        struct str_list* next;
    } str_list_t;

    typedef struct ptr_list
    {
        void* ptr;
        struct ptr_list* next;
    } ptr_list_t;

    enum FileType
    {
        Unknown = -1,
        MPEG = 0,
        Ogg_Vorbis,
        FLAC,
        MPC,
        WavPack,
        Ogg_Speex,
        Ogg_Opus,
        TrueAudio,
        MP4,
        ASF,
        RIFF_AIFF,
        RIFF_WAV,
        APE,
        Mod,
        S3M,
        IT,
        XM,
    };

    static inline cr_string_t* taglib_str_to_cr(TagLib::String taglib_str)
    {
        // convert taglib strings to something we can use from crystal.
        // as the std::strings returned are only temporary,  allocate some memory for the lifetime
        // of the string.  needs to be free'd later on.

        std::string s = taglib_str.to8Bit(true);
        void* sdata = malloc(s.size());
        strncpy(reinterpret_cast<char*>(sdata), s.c_str(), s.size());

        return new cr_string_t{.data = reinterpret_cast<char*>(sdata), .length = s.size()};
    }

    void* cr_taglib_fileref_new(const char* filename)
    {
        return reinterpret_cast<void*>(new TagLib::FileRef(filename));
    }

    void cr_taglib_fileref_delete(void* fileref)
    {
        delete reinterpret_cast<TagLib::FileRef*>(fileref);
    }

    void* cr_taglib_fileref_audio_properties(void* fileref)
    {
        return reinterpret_cast<TagLib::AudioProperties*>(
            reinterpret_cast<TagLib::FileRef*>(fileref)->audioProperties());
    }

    void* cr_taglib_fileref_file(void* fileref)
    {
        return reinterpret_cast<TagLib::File*>(reinterpret_cast<TagLib::FileRef*>(fileref)->file());
    }

    void* cr_taglib_fileref_tag(void* fileref)
    {
        return reinterpret_cast<TagLib::Tag*>(reinterpret_cast<TagLib::FileRef*>(fileref)->tag());
    }

    int cr_taglib_audio_properties_bitrate(void* audio_properties)
    {
        return reinterpret_cast<TagLib::AudioProperties*>(audio_properties)->bitrate();
    }

    int cr_taglib_audio_properties_channels(void* audio_properties)
    {
        return reinterpret_cast<TagLib::AudioProperties*>(audio_properties)->channels();
    }

    int cr_taglib_audio_properties_length(void* audio_properties)
    {
        return reinterpret_cast<TagLib::AudioProperties*>(audio_properties)->length();
    }

    int cr_taglib_audio_properties_length_in_seconds(void* audio_properties)
    {
        return reinterpret_cast<TagLib::AudioProperties*>(audio_properties)->lengthInSeconds();
    }

    int cr_taglib_audio_properties_length_in_milliseconds(void* audio_properties)
    {
        return reinterpret_cast<TagLib::AudioProperties*>(audio_properties)->lengthInMilliseconds();
    }

    int cr_taglib_audio_properties_sample_rate(void* audio_properties)
    {
        return reinterpret_cast<TagLib::AudioProperties*>(audio_properties)->sampleRate();
    }

    FileType cr_taglib_file_class(void* file)
    {
        auto f = reinterpret_cast<TagLib::File*>(file);

        if (dynamic_cast<TagLib::MPEG::File*>(f) != nullptr)
        {
            return FileType::MPEG;
        }
        if (dynamic_cast<TagLib::Ogg::Vorbis::File*>(f) != nullptr)
        {
            return FileType::Ogg_Vorbis;
        }
        if (dynamic_cast<TagLib::FLAC::File*>(f) != nullptr)
        {
            return FileType::FLAC;
        }
        if (dynamic_cast<TagLib::MPC::File*>(f) != nullptr)
        {
            return FileType::MPC;
        }
        if (dynamic_cast<TagLib::WavPack::File*>(f) != nullptr)
        {
            return FileType::WavPack;
        }
        if (dynamic_cast<TagLib::Ogg::Speex::File*>(f) != nullptr)
        {
            return FileType::Ogg_Speex;
        }
        if (dynamic_cast<TagLib::Ogg::Opus::File*>(f) != nullptr)
        {
            return FileType::Ogg_Opus;
        }
        if (dynamic_cast<TagLib::TrueAudio::File*>(f) != nullptr)
        {
            return FileType::TrueAudio;
        }
        if (dynamic_cast<TagLib::MP4::File*>(f) != nullptr)
        {
            return FileType::MP4;
        }
        if (dynamic_cast<TagLib::ASF::File*>(f) != nullptr)
        {
            return FileType::ASF;
        }
        if (dynamic_cast<TagLib::RIFF::AIFF::File*>(f) != nullptr)
        {
            return FileType::RIFF_AIFF;
        }
        if (dynamic_cast<TagLib::RIFF::WAV::File*>(f) != nullptr)
        {
            return FileType::RIFF_WAV;
        }
        if (dynamic_cast<TagLib::APE::File*>(f) != nullptr)
        {
            return FileType::APE;
        }
        if (dynamic_cast<TagLib::Mod::File*>(f) != nullptr)
        {
            return FileType::Mod;
        }
        if (dynamic_cast<TagLib::S3M::File*>(f) != nullptr)
        {
            return FileType::S3M;
        }
        if (dynamic_cast<TagLib::IT::File*>(f) != nullptr)
        {
            return FileType::IT;
        }
        if (dynamic_cast<TagLib::XM::File*>(f) != nullptr)
        {
            return FileType::XM;
        }

        return FileType::Unknown;
    }

    str_list_t* cr_taglib_file_properties(void* file)
    {
        auto f = reinterpret_cast<TagLib::File*>(file);
        TagLib::PropertyMap tags = f->properties();
        str_list_t* list_head = new str_list_t{.str = nullptr, .next = nullptr};
        str_list_t* tail = list_head;

        for (TagLib::PropertyMap::ConstIterator i = tags.begin(); i != tags.end(); ++i)
        {
            for (TagLib::StringList::ConstIterator j = i->second.begin(); j != i->second.end(); ++j)
            {
                tail->str = taglib_str_to_cr(i->first);

                str_list_t* last = new str_list_t{.str = taglib_str_to_cr(*j), .next = nullptr};
                tail->next = last;
                tail = last;

                last = new str_list_t{.str = nullptr, .next = nullptr};
                tail->next = last;
                tail = last;
            }
        }

        return list_head;
    }

    cr_string_t* cr_taglib_tag_title(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return taglib_str_to_cr(t->title());
    }

    cr_string_t* cr_taglib_tag_artist(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return taglib_str_to_cr(t->artist());
    }

    cr_string_t* cr_taglib_tag_album(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return taglib_str_to_cr(t->album());
    }

    cr_string_t* cr_taglib_tag_comment(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return taglib_str_to_cr(t->comment());
    }

    cr_string_t* cr_taglib_tag_genre(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return taglib_str_to_cr(t->genre());
    }

    uint32_t cr_taglib_tag_year(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return t->year();
    }

    uint32_t cr_taglib_tag_track(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return t->track();
    }

    int cr_taglib_tag_is_empty(void* tag)
    {
        auto t = reinterpret_cast<TagLib::Tag*>(tag);
        return t->isEmpty();
    }

    ptr_list_t* cr_taglib_flac_file_picture_list(void* flac_file)
    {
        auto f = reinterpret_cast<TagLib::FLAC::File*>(flac_file);
        TagLib::List<TagLib::FLAC::Picture*> pictures = f->pictureList();
        ptr_list_t* list_head = new ptr_list_t{.ptr = nullptr, .next = nullptr};
        ptr_list_t* tail = list_head;

        for (TagLib::List<TagLib::FLAC::Picture*>::ConstIterator i = pictures.begin(); i != pictures.end(); ++i)
        {
            tail->ptr = *i;

            ptr_list_t* last = new ptr_list_t{.ptr = nullptr, .next = nullptr};
            tail->next = last;
            tail = last;
        }

        return list_head;
    }

    int cr_taglib_flac_picture_type(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        return p->type();
    }

    cr_string_t* cr_taglib_flac_picture_data(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        auto d = p->data();

        // Since the data is represented as a char* internally, we can just reuse
        // the cr_string_t struct to later create a Slice(UInt8) in Crystal.
        return new cr_string_t{.data = d.data(), .length = d.size()};
    }

    cr_string_t* cr_taglib_flac_picture_mime_type(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        return taglib_str_to_cr(p->mimeType());
    }

    cr_string_t* cr_taglib_flac_picture_description(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        return taglib_str_to_cr(p->description());
    }

    int cr_taglib_flac_picture_width(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        return p->width();
    }

    int cr_taglib_flac_picture_height(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        return p->height();
    }

    int cr_taglib_flac_picture_color_depth(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        return p->colorDepth();
    }

    int cr_taglib_flac_picture_num_colors(void* flac_picture)
    {
        auto p = reinterpret_cast<TagLib::FLAC::Picture*>(flac_picture);
        return p->numColors();
    }

    void cr_taglib_free_str(cr_string_t* str, int free_string)
    {
        if (free_string)
        {
            free(const_cast<char*>(str->data));
        }
        delete str;
    }

    void cr_taglib_free_str_list(str_list_t* list)
    {
        auto last = list->next;
        while (last != nullptr)
        {
            cr_taglib_free_str(list->str, true);
            delete list;
            list = last;
            last = list->next;
        }
    }

    void cr_taglib_free_ptr_list(ptr_list_t* list)
    {
        auto last = list->next;
        while (last != nullptr)
        {
            delete list;
            list = last;
            last = list->next;
        }
    }
}
