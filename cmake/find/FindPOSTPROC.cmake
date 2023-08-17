find_path(POSTPROC_INCLUDE_DIR
        NAMES libpostproc/postprocess.h
        HINTS ${FFMPEG_PATH_ROOT}
        PATH_SUFFIXES include)

if (FFMPEG_USE_STATIC_LIBS)
    find_library(POSTPROC_LIBRARY
            NAMES libpostproc.a
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
else()
    find_library(POSTPROC_LIBRARY
            NAMES libpostproc.so
            HINTS ${FFMPEG_PATH_ROOT}
            PATH_SUFFIXES bin lib)
endif ()
set(POSTPROC_LIBRARIES ${POSTPROC_LIBRARY})
set(POSTPROC_INCLUDE_DIRS ${POSTPROC_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(POSTPROC DEFAULT_MSG POSTPROC_LIBRARY POSTPROC_INCLUDE_DIR)
