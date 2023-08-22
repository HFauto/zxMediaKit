#
# Created by HFauto on 2022/12/27.
#

if (KAFKA STREQUAL "y")
    if (ENABLE_WORKFLOW_KAFKA_STATIC)
        set(snappy_lib_names libsnappy.a)
        set(lz4_lib_names liblz4.a)
        set(zstd_lib_names libzstd.a)
    else()
        set(snappy_lib_names snappy)
        set(lz4_lib_names lz4)
        set(zstd_lib_names zstd)
    endif ()
    #zstd
    find_path(ZSTD_INCLUDE_PATH NAMES zstd_errors.h)
    find_library(ZSTD_LIB NAMES ${zstd_lib_names})
    if ((NOT ZSTD_INCLUDE_PATH) OR (NOT ZSTD_LIB))
        if(EXISTS "${CMAKE_SOURCE_DIR}/extern/zstd/lib")
            EXECUTE_PROCESS(
                    COMMAND cmake . -DZSTD_BUILD_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/zstd/build/cmake RESULT_VARIABLE ret)
            EXECUTE_PROCESS(
                    COMMAND make -j${BUILD_CPU_NUM}
                    COMMAND make install
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/zstd/build/cmake RESULT_VARIABLE ret)
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
        else()
            if(EXISTS "${CMAKE_SOURCE_DIR}/extern/zstd-1.5.2.tar.gz")
                message(STATUS "zstd install from '${CMAKE_SOURCE_DIR}/extern/zstd-1.5.2.tar.gz'")
                EXECUTE_PROCESS(
                        COMMAND rm -rf zstd
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern RESULT_VARIABLE ret)
                EXECUTE_PROCESS(
                        COMMAND tar -xzvf zstd-1.5.2.tar.gz
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern RESULT_VARIABLE ret)
                EXECUTE_PROCESS(
                        COMMAND mv zstd-1.5.2 zstd
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern RESULT_VARIABLE ret)
                if(NOT ret EQUAL 0)
                    message(FATAL_ERROR "FAILED: ${ret}")
                endif()
            endif()
            if(EXISTS "${CMAKE_SOURCE_DIR}/extern/zstd/lib")
                EXECUTE_PROCESS(
                        COMMAND cmake . -DZSTD_BUILD_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/zstd/build/cmake RESULT_VARIABLE ret)
                if(NOT ret EQUAL 0)
                    message(FATAL_ERROR "FAILED: ${ret}")
                endif()
                EXECUTE_PROCESS(
                        COMMAND make -j${BUILD_CPU_NUM}
                        COMMAND make install
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/zstd/build/cmake RESULT_VARIABLE ret)
                if(NOT ret EQUAL 0)
                    message(FATAL_ERROR "FAILED: ${ret}")
                endif()
            else()
                message(STATUS "zstd src not find")
            endif()
        endif ()
    endif ()
    find_path(ZSTD_INCLUDE_PATH NAMES zstd_errors.h)
    find_library(ZSTD_LIB NAMES ${zstd_lib_names})
    if ((NOT ZSTD_INCLUDE_PATH) OR (NOT ZSTD_LIB))
        message(FATAL_ERROR "Fail to find zstd with KAFKA=y")
    else()
        message(STATUS "zstd find ${ZSTD_LIB}")
    endif ()
    #snappy
    find_path(SNAPPY_INCLUDE_PATH NAMES snappy.h)
    find_library(SNAPPY_LIB NAMES ${snappy_lib_names})
    if ((NOT SNAPPY_INCLUDE_PATH) OR (NOT SNAPPY_LIB))
        if(EXISTS "${CMAKE_SOURCE_DIR}/extern/snappy/src")
            EXECUTE_PROCESS(
                    COMMAND cmake . -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/snappy RESULT_VARIABLE ret)
            EXECUTE_PROCESS(
                    COMMAND make -j${BUILD_CPU_NUM}
                    COMMAND make install
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/snappy RESULT_VARIABLE ret)
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
        else()
            if(EXISTS "${CMAKE_SOURCE_DIR}/extern/snappy.zip")
                message(STATUS "snappy install from '${CMAKE_SOURCE_DIR}/extern/snappy.zip'")
                EXECUTE_PROCESS(
                        COMMAND rm -rf snappy
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern RESULT_VARIABLE ret)
                EXECUTE_PROCESS(
                        COMMAND unzip snappy.zip -d ${CMAKE_SOURCE_DIR}/extern/snappy
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern RESULT_VARIABLE ret)
            else()
                message(STATUS "snappy install from github")
                FetchContent_Declare(
                        snappy
                        GIT_REPOSITORY https://github.com/google/snappy.git
                        GIT_TAG main
                        SOURCE_DIR ${CMAKE_SOURCE_DIR}/extern/snappy)
                FetchContent_MakeAvailable(snappy)
            endif()
            if(EXISTS "${CMAKE_SOURCE_DIR}/extern/snappy/cmake")
                EXECUTE_PROCESS(
                        COMMAND cmake . -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/snappy RESULT_VARIABLE ret)
                EXECUTE_PROCESS(
                        COMMAND make -j${BUILD_CPU_NUM}
                        COMMAND make install
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/snappy RESULT_VARIABLE ret)
                if(NOT ret EQUAL 0)
                    message(FATAL_ERROR "FAILED: ${ret}")
                endif()
            else()
                message(STATUS "snappy src not find")
            endif()
        endif ()
    endif ()
    find_path(SNAPPY_INCLUDE_PATH NAMES snappy.h)
    find_library(SNAPPY_LIB NAMES ${snappy_lib_names})
    if ((NOT SNAPPY_INCLUDE_PATH) OR (NOT SNAPPY_LIB))
        message(FATAL_ERROR "Fail to find snappy with KAFKA=y")
    else()
        message(STATUS "snappy find ${SNAPPY_LIB}")
    endif ()
    include_directories(${SNAPPY_INCLUDE_PATH})
    #lz4
    find_path(LZ4_INCLUDE_PATH NAMES lz4.h)
    find_library(LZ4_LIB NAMES ${lz4_lib_names})
    if ((NOT LZ4_INCLUDE_PATH) OR (NOT LZ4_LIB))
        if(EXISTS "${CMAKE_SOURCE_DIR}/extern/lz4-1.9.4.tar.gz")
            message(STATUS "lz4 install from '${CMAKE_SOURCE_DIR}/extern/lz4-1.9.4.tar.gz'")
            EXECUTE_PROCESS(
                    COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/lz4
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            EXECUTE_PROCESS(
                    COMMAND ${CMAKE_COMMAND} -E tar xzvf ${CMAKE_CURRENT_SOURCE_DIR}/extern/lz4-1.9.4.tar.gz
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            EXECUTE_PROCESS(
                    COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/lz4-1.9.4 ${CMAKE_CURRENT_SOURCE_DIR}/extern/lz4
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            EXECUTE_PROCESS(
                    COMMAND cmake . -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/lz4/build/cmake RESULT_VARIABLE ret
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            EXECUTE_PROCESS(
                    COMMAND make -j${BUILD_CPU_NUM}
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/lz4/build/cmake RESULT_VARIABLE ret
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            EXECUTE_PROCESS(
                    COMMAND make install
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/extern/lz4/build/cmake RESULT_VARIABLE ret
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
        endif()
    endif ()
    find_path(LZ4_INCLUDE_PATH NAMES lz4.h)
    find_library(LZ4_LIB NAMES ${lz4_lib_names})
    if ((NOT LZ4_INCLUDE_PATH) OR (NOT LZ4_LIB))
        message(FATAL_ERROR "Fail to find lz4 with KAFKA=y")
    else()
        message(STATUS "lz4 find ${LZ4_LIB}")
    endif ()
    #更新链接
    if (ENABLE_WORKFLOW_STATIC)
        update_cached_list(ZX_LINK_LIBRARIES workflow-static libz.a ${LZ4_LIB} ${ZSTD_LIB} ${SNAPPY_LIB})
    else()
        update_cached_list(ZX_LINK_LIBRARIES workflow-shared z ${LZ4_LIB} ${ZSTD_LIB} ${SNAPPY_LIB})
    endif ()
endif ()