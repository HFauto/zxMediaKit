#
# Created by HFauto on 2022/12/27.
#

if (ENABLE_BUILD_TEST)
    file(GLOB src_dirs ${PROJECT_SOURCE_DIR}/src/*)
    foreach(src_dir  ${src_dirs})
        if (IS_DIRECTORY ${src_dir})
            include_directories(${src_dir})
        endif ()
    endforeach()
    file(GLOB testOtherList LIST_DIRECTORIES false
    )
    file(GLOB_RECURSE testSrcList
            ${PROJECT_SOURCE_DIR}/test/*.cpp
            ${PROJECT_SOURCE_DIR}/test/*.cc
            ${PROJECT_SOURCE_DIR}/test/*.c
    )
    FOREACH(FILE_PATH ${testSrcList})
        STRING(REGEX REPLACE ".+/(.+)\\..*" "\\1" FILE_NAME ${FILE_PATH})
        add_executable(${FILE_NAME} ${FILE_PATH} ${testOtherList})
        message(STATUS "add test ${FILE_NAME}")
        if (ENABLE_MEDIA_SERVICE_STATIC)
            target_link_libraries(${FILE_NAME} PUBLIC -Wl,--start-group ${ZX_MEDIA_STATIC_LIB_NAME} -Wl,--end-group)
        else()
            target_link_libraries(${FILE_NAME} PUBLIC -Wl,--start-group ${ZX_MEDIA_SHARED_LIB_NAME} -Wl,--end-group)
        endif ()
        install(TARGETS     ${FILE_NAME}     DESTINATION ${PROJECT_INSTALL_APPDIR})
    ENDFOREACH(FILE_PATH)
endif()