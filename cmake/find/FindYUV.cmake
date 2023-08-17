find_path(YUV_INCLUDE_DIR
        NAMES libyuv.h
        HINTS ${YUV_PATH_ROOT}
        PATH_SUFFIXES include)

if (ENABLE_LIBYUV_STATIC)
    find_library(YUV_LIBRARY
            NAMES libyuv.a
            HINTS ${YUV_PATH_ROOT}
            PATH_SUFFIXES bin lib)
else()
    find_library(YUV_LIBRARY
            NAMES libyuv.so
            HINTS ${YUV_PATH_ROOT}
            PATH_SUFFIXES bin lib)
endif ()

set(YUV_LIBRARIES ${YUV_LIBRARY})
set(YUV_INCLUDE_DIRS ${YUV_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(YUV DEFAULT_MSG YUV_LIBRARY YUV_INCLUDE_DIR)