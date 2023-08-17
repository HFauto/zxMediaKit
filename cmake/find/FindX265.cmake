#
# Created by HFauto on 2023/1/16.
#
include(CMakePushCheckState)
include(CheckCXXSymbolExists)

set(_X265_ROOT_PATHS
    ${CMAKE_INSTALL_PREFIX}
    ${EXTERN_INSTALL_DIR}
)

find_path(X265_INCLUDE_DIRS
        NAMES x265.h
        HINTS _X265_ROOT_PATHS
        PATH_SUFFIXES include
        )
if(X265_INCLUDE_DIRS)
    set(HAVE_X265_H 1)
endif()

if (ENABLE_X265_STATIC)
    find_library(X265_LIBRARIES
            NAMES libx265.a
            HINTS _X265_ROOT_PATHS
            PATH_SUFFIXES bin lib
            )
else()
    find_library(X265_LIBRARIES
            NAMES x265
            HINTS _X265_ROOT_PATHS
            PATH_SUFFIXES bin lib
            )
endif ()


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(X265
        DEFAULT_MSG
        X265_INCLUDE_DIRS X265_LIBRARIES HAVE_X265_H
        )

mark_as_advanced(X265_INCLUDE_DIRS X265_LIBRARIES HAVE_X265_H)