find_path(SWRESAMPLE_INCLUDE_DIR
        NAMES libswresample/swresample.h
        HINTS ${FFMPEG_PATH_ROOT}
        PATH_SUFFIXES include)


if (FFMPEG_USE_STATIC_LIBS)
    find_library(SWRESAMPLE_LIBRARY
            NAMES libswresample.a
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
else()
    find_library(SWRESAMPLE_LIBRARY
            NAMES libswresample.so
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
endif ()

set(SWRESAMPLE_LIBRARIES ${SWRESAMPLE_LIBRARY})
set(SWRESAMPLE_INCLUDE_DIRS ${SWRESAMPLE_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(SWRESAMPLE DEFAULT_MSG SWRESAMPLE_LIBRARY SWRESAMPLE_INCLUDE_DIR)
