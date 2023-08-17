find_path(AVFILTER_INCLUDE_DIR
        NAMES libavfilter/avfilter.h
        HINTS ${FFMPEG_PATH_ROOT}
        PATH_SUFFIXES include)

if (FFMPEG_USE_STATIC_LIBS)
    find_library(AVFILTER_LIBRARY
            NAMES libavfilter.a
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
else()
    find_library(AVFILTER_LIBRARY
            NAMES libavfilter.so
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
endif ()

set(AVFILTER_LIBRARIES ${AVFILTER_LIBRARY})
set(AVFILTER_INCLUDE_DIRS ${AVFILTER_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(AVFILTER DEFAULT_MSG AVFILTER_LIBRARY AVFILTER_INCLUDE_DIR)