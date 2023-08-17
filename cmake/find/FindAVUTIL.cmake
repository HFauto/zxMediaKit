find_path(AVUTIL_INCLUDE_DIR
        NAMES libavutil/avutil.h
        HINTS ${FFMPEG_PATH_ROOT}
        PATH_SUFFIXES include)

if (FFMPEG_USE_STATIC_LIBS)
    find_library(AVUTIL_LIBRARY
            NAMES libavutil.a
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
else()
    find_library(AVUTIL_LIBRARY
            NAMES libavutil.so
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
endif ()
set(AVUTIL_LIBRARIES ${AVUTIL_LIBRARY})
set(AVUTIL_INCLUDE_DIRS ${AVUTIL_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(AVUTIL DEFAULT_MSG AVUTIL_LIBRARY AVUTIL_INCLUDE_DIR)
