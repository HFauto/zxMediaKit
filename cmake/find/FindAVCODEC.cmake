find_path(AVCODEC_INCLUDE_DIR
        NAMES libavcodec/avcodec.h
        HINTS ${FFMPEG_PATH_ROOT}
        PATH_SUFFIXES include)

if (FFMPEG_USE_STATIC_LIBS)
    find_library(AVCODEC_LIBRARY
            NAMES libavcodec.a
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
else()
    find_library(AVCODEC_LIBRARY
            NAMES libavcodec.so
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
endif ()

set(AVCODEC_LIBRARIES ${AVCODEC_LIBRARY})
set(AVCODEC_INCLUDE_DIRS ${AVCODEC_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(AVCODEC DEFAULT_MSG AVCODEC_LIBRARY AVCODEC_INCLUDE_DIR)