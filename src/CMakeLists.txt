#
# Created by HFauto on 2023/1/9.
# Copyright (c) 2023 HFauto. All rights reserved.
#
cmake_minimum_required(VERSION 3.12...3.25)

file(GLOB src_dirs ${CMAKE_CURRENT_SOURCE_DIR}/*)
foreach(src_dir  ${src_dirs})
    if (IS_DIRECTORY ${src_dir})
        if (EXISTS ${src_dir}/CMakeLists.txt)
            include_directories(${src_dir})
        endif ()
    endif ()
endforeach()

file(GLOB src_dirs ${CMAKE_CURRENT_SOURCE_DIR}/*)
foreach(src_dir  ${src_dirs})
    if (IS_DIRECTORY ${src_dir})
        if (EXISTS ${src_dir}/CMakeLists.txt)
            add_subdirectory(${src_dir})
        endif ()
    endif ()
endforeach()

add_dependencies(zltoolkit)
add_dependencies(zx_log)
add_dependencies(zx_base)
add_dependencies(zx_tools)
add_dependencies(zx_util)


set(STATIC_LIB_NAME ${PROJECT_NAME}_static)
set(SHARED_LIB_NAME ${PROJECT_NAME}_shared)
set(ZX_MEDIA_STATIC_LIB_NAME ${STATIC_LIB_NAME} PARENT_SCOPE)
set(ZX_MEDIA_SHARED_LIB_NAME ${SHARED_LIB_NAME} PARENT_SCOPE)

if (ENABLE_MEDIA_SERVICE_STATIC)
    add_library(
            ${STATIC_LIB_NAME} STATIC
            $<TARGET_OBJECTS:zltoolkit>
            $<TARGET_OBJECTS:zx_log>
            $<TARGET_OBJECTS:zx_base>
            $<TARGET_OBJECTS:zx_tools>
            $<TARGET_OBJECTS:zx_util>
            $<TARGET_OBJECTS:zx_ffmcpp>
    )
    target_link_libraries(${STATIC_LIB_NAME} -Wl,--start-group ${ZX_LINK_LIBRARIES} -Wl,--end-group)
    install(
            TARGETS ${STATIC_LIB_NAME}
            ARCHIVE DESTINATION ${PROJECT_INSTALL_LIBDIR}
            COMPONENT devel
    )
else()
    add_library(
            ${SHARED_LIB_NAME} SHARED
            $<TARGET_OBJECTS:zltoolkit>
            $<TARGET_OBJECTS:zx_log>
            $<TARGET_OBJECTS:zx_base>
            $<TARGET_OBJECTS:zx_tools>
            $<TARGET_OBJECTS:zx_util>
            $<TARGET_OBJECTS:zx_ffmcpp>
    )
    target_link_libraries(${SHARED_LIB_NAME} -Wl,--start-group ${ZX_LINK_LIBRARIES} -Wl,--end-group)
    install(
            TARGETS ${SHARED_LIB_NAME}
            LIBRARY DESTINATION ${PROJECT_INSTALL_LIBDIR}
            COMPONENT devel
    )
endif ()



