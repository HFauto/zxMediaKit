#
# Created by HFauto on 2022/12/26.
#

# 下载openssl
if(ENABLE_OPENSSL)
    # 安装openssl
    if(EXISTS "${EXTERN_INSTALL_DIR}/bin/openssl")
        message(STATUS "openssl exe exists")
    else()
        # 下载openssl
        EXECUTE_PROCESS(
                COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/openssl
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
        )
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/openssl-1.1.1s.tar.gz")
            message(STATUS "openssl zip exists")
            execute_process(
                    COMMAND tar -xzvf ${CMAKE_CURRENT_SOURCE_DIR}/extern/openssl-1.1.1s.tar.gz
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
            execute_process(
                    COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/openssl-1.1.1s ${CMAKE_CURRENT_SOURCE_DIR}/extern/openssl
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
        endif()
        #install
        EXECUTE_PROCESS(
                COMMAND ./config --prefix=${EXTERN_INSTALL_DIR}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/openssl RESULT_VARIABLE ret)
        EXECUTE_PROCESS(
                COMMAND make -j${BUILD_CPU_NUM}
                COMMAND make install
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/openssl RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
    endif()
    # 查找 openssl 是否安装
    set(OPENSSL_ROOT_DIR ${EXTERN_INSTALL_DIR})
    if (ENABLE_OPENSSL_STATIC)
        set(OPENSSL_USE_STATIC_LIBS TRUE)
    else()
        set(OPENSSL_USE_STATIC_LIBS FALSE)
    endif()
    find_package(OpenSSL QUIET)
    if(OPENSSL_FOUND AND ENABLE_OPENSSL)
        message(STATUS "found library: ${OPENSSL_LIBRARIES}, ENABLE_OPENSSL defined")
        include_directories(${OPENSSL_INCLUDE_DIR})
        update_cached_list(MK_COMPILE_DEFINITIONS ENABLE_OPENSSL)
        update_cached_list(ZX_LINK_LIBRARIES ${OPENSSL_LIBRARIES})
        if(CMAKE_SYSTEM_NAME MATCHES "Linux" AND OPENSSL_USE_STATIC_LIBS)
            update_cached_list(ZX_LINK_LIBRARIES ${CMAKE_DL_LIBS})
        endif()
    else()
        set(ENABLE_OPENSSL OFF)
        set(ENABLE_WEBRTC OFF)
        message(WARNING "openssl 未找到, rtmp 将不支持 flash 播放器, https/wss/rtsps/rtmps/webrtc 也将失效")
    endif()
endif()