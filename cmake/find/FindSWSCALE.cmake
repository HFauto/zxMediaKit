find_path(SWSCALE_INCLUDE_DIR
        NAMES libswscale/swscale.h
        HINTS ${FFMPEG_PATH_ROOT}
        PATH_SUFFIXES include)

if (FFMPEG_USE_STATIC_LIBS)
    find_library(SWSCALE_LIBRARY
            NAMES libswscale.a
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
else()
    find_library(SWSCALE_LIBRARY
            NAMES libswscale.so
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
endif ()


set(SWSCALE_LIBRARIES ${SWSCALE_LIBRARY})
set(SWSCALE_INCLUDE_DIRS ${SWSCALE_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(SWSCALE DEFAULT_MSG SWSCALE_LIBRARY SWSCALE_INCLUDE_DIR)
