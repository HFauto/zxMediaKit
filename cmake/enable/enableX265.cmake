#
# Created by HFauto on 2022/12/26.
#
if (ENABLE_X265)
    if(EXISTS "${EXTERN_INSTALL_DIR}/bin/x265")
        message(STATUS "libx265 exe exists")
    else()
        EXECUTE_PROCESS(
                COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx265
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
        )
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/x265-2.7.tar.bz2")
            message(STATUS "libx264 zip exists")
            execute_process(
                    COMMAND tar -jxvf x265-2.7.tar.bz2
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/multicoreware-x265-e41a9bf2bac4")
                execute_process(
                        COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/multicoreware-x265-e41a9bf2bac4 ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx265
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
                COMMAND cmake ../../source -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=ON -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx265/build/linux RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        execute_process(
                COMMAND make -j${BUILD_CPU_NUM}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx265/build/linux RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        execute_process(
                COMMAND make install
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libx265/build/linux RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
    endif()
    find_package(X265 REQUIRED)
    message(STATUS "find libx265 library: ${X265_LIBRARIES}")
    #libyuv link
    update_cached_list(ZX_LINK_LIBRARIES ${X265_LIBRARIES})
endif()