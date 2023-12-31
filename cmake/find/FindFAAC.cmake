

find_path(FAAC_INCLUDE_DIR
  NAMES faac.h
)

if (FAAC_USE_STATIC_LIBS)
    find_library(FAAC_LIBRARY
            NAMES libfaac.a
            )
else()
    find_library(FAAC_LIBRARY
            NAMES libfaac.so
            )
endif ()

set(FAAC_INCLUDE_DIRS ${FAAC_INCLUDE_DIR})
set(FAAC_LIBRARIES ${FAAC_LIBRARY})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(FAAC DEFAULT_MSG FAAC_LIBRARY FAAC_INCLUDE_DIR)
