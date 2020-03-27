#include <cstring>
#include <taglib/fileref.h>
#include <taglib/tpropertymap.h>

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

    void cr_taglib_free_str(cr_string_t* str)
    {
        free(const_cast<char*>(str->data));
        delete str;
    }

    void cr_taglib_free_str_list(str_list_t* list)
    {
        auto last = list->next;
        while (last != nullptr)
        {
            cr_taglib_free_str(list->str);
            delete list;
            list = last;
            last = list->next;
        }
    }
}
