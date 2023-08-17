#
# Created by HFauto on 2023/1/3.
#
if (ENABLE_JEMALLOC)
    set(DEP_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/external-${CMAKE_SYSTEM_NAME})
    if(ENABLE_JEMALLOC_STATIC)
        if(NOT EXISTS ${DEP_ROOT_DIR})
            file(MAKE_DIRECTORY ${DEP_ROOT_DIR})
        endif()

        include(Jemalloc)
        include_directories(SYSTEM ${DEP_ROOT_DIR}/${JEMALLOC_NAME}/include/jemalloc)
        link_directories(${DEP_ROOT_DIR}/${JEMALLOC_NAME}/lib)
        # 用于影响后续查找过程
        set(JEMALLOC_ROOT_DIR "${DEP_ROOT_DIR}/${JEMALLOC_NAME}")
    endif()

    # 默认链接 jemalloc 库避免内存碎片
    find_package(JEMALLOC QUIET)
    if(JEMALLOC_FOUND)
        message(STATUS "found library: ${JEMALLOC_LIBRARIES}")
        include_directories(${JEMALLOC_INCLUDE_DIR})
        update_cached_list(ZX_LINK_LIBRARIES ${JEMALLOC_LIBRARIES})
    endif()
endif ()
