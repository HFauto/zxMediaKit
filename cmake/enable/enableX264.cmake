#
# Created by HFauto on 2022/12/26.
#
if (ENABLE_X264)
    if(EXISTS "${EXTERN_INSTALL_DIR}/bin/x264")
        message(STATUS "libx264 exe exists")
    else()
        EXECUTE_PROCESS(
                COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx264
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
        )
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/x264-master.tar.bz2")
            message(STATUS "libx264 zip exists")
            execute_process(
                    COMMAND tar -jxvf x264-master.tar.bz2
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/x264-master")
                execute_process(
                        COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/x264-master ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx264
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
                        RESULT_VARIABLE ret
                )
            endif()
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
        endif()
        #install
        execute_process(
                COMMAND ./configure --disable-opencl --enable-static --enable-shared --prefix=${EXTERN_INSTALL_DIR}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx264 RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        execute_process(
                COMMAND make -j
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx264 RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        execute_process(
                COMMAND make install
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx264 RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
    endif()
    find_package(X264 REQUIRED)
    message(STATUS "find libx264 library: ${X264_LIBRARIES}")
    #libyuv link
    update_cached_list(ZX_LINK_LIBRARIES ${X264_LIBRARIES})
endif ()