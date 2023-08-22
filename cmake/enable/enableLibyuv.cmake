#
# Created by HFauto on 2022/12/26.
#
if(ENABLE_LIBYUV)
    #libjpeg
    if (ENABLE_LIBYUV_STATIC)
        set(JPEG_NAMES libjpeg.a)
    else()
        set(JPEG_NAMES libjpeg.so)
    endif()
    set(JPEG_PATH_ROOT ${EXTERN_INSTALL_DIR})
    if(EXISTS "${EXTERN_INSTALL_DIR}/bin/jpegtran")
        message(STATUS "jpeg exe exists")
    else()
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/libjpeg-turbo-2.1.4.tar.gz")
            message(STATUS "libjpeg-turbo zip exists")
            execute_process(
                    COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/libjpeg
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
            )
            execute_process(
                    COMMAND ${CMAKE_COMMAND} -E tar xzvf ${CMAKE_CURRENT_SOURCE_DIR}/extern/libjpeg-turbo-2.1.4.tar.gz
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
            execute_process(
                    COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/libjpeg-turbo-2.1.4 ${CMAKE_CURRENT_SOURCE_DIR}/extern/libjpeg
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
        endif()
        #libjpeg install
        execute_process(
                COMMAND cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libjpeg RESULT_VARIABLE ret)
        execute_process(
                COMMAND make -j${BUILD_CPU_NUM}
                COMMAND make install
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libjpeg RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
    endif()
    find_package(JPEG REQUIRED)
    message(STATUS "find jpeg library: ${JPEG_LIBRARY}")
    #libjpeg link
    update_cached_list(ZX_LINK_LIBRARIES ${JPEG_LIBRARY})
    #libyuv
    set(YUV_PATH_ROOT ${EXTERN_INSTALL_DIR})
    # 安装
    if(EXISTS "${EXTERN_INSTALL_DIR}/bin/yuvconvert")
        message(STATUS "yuv exe exists")
    else()
        EXECUTE_PROCESS(
                COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
        )
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv-main.zip")
            message(STATUS "libyuv zip exists")
            execute_process(
                    COMMAND unzip -o ${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv-main.zip -d libyuv
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/

            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv-main")
                execute_process(
                        COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv-main ${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv
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
                COMMAND cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        execute_process(
                COMMAND make -j${BUILD_CPU_NUM}
                COMMAND make install
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/libyuv RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
    endif()
    find_package(YUV REQUIRED)
    message(STATUS "find yuv library: ${YUV_LIBRARY}")
    #libyuv link
    update_cached_list(ZX_LINK_LIBRARIES ${YUV_LIBRARY})
endif()