#
# Created by HFauto on 2022/12/26.
#

# 发现ffmpeg
if(ENABLE_FFMPEG)
    if (ENABLE_FFMPEG_STATIC)
        set(FFMPEG_USE_STATIC_LIBS TRUE)
    else()
        set(FFMPEG_USE_STATIC_LIBS FALSE)
    endif()
    # 安装ffmpeg
    if(EXISTS "${EXTERN_INSTALL_DIR}/bin/ffmpeg")
        message(STATUS "ffmpeg exe exists")
    else()
        # 下载ffmpeg
        execute_process(
                COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/ffmpeg
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
        )
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/FFmpeg-release-5.1.zip")
            message(STATUS "ffmpeg zip exists")
            execute_process(
                    COMMAND unzip ${CMAKE_CURRENT_SOURCE_DIR}/extern/FFmpeg-release-5.1.zip
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
            execute_process(
                    COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/FFmpeg-release-5.1 ${CMAKE_CURRENT_SOURCE_DIR}/extern/ffmpeg
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
        endif()
        set(FFM_CONF
                --enable-gpl
                --enable-version3
                --enable-pic
                --enable-nonfree
                --disable-lzma
                --disable-bzlib
                --enable-nonfree
                --disable-ffplay
                --disable-ffprobe
                --disable-doc
                --disable-htmlpages
                --enable-shared
                --enable-static
                --extra-cflags=-I${EXTERN_INSTALL_DIR}/include
                --extra-ldflags=-L${EXTERN_INSTALL_DIR}/lib
                )
        if(ENABLE_X264 AND ENABLE_X265)
            set(BUILD_COMMAND ./configure ${FFM_CONF} --enable-libx264 --enable-libx265 --prefix=${EXTERN_INSTALL_DIR})
        elseif(ENABLE_X264)
            set(BUILD_COMMAND ./configure ${FFM_CONF}  --enable-libx264 --prefix=${EXTERN_INSTALL_DIR})
        elseif(ENABLE_X265)
            set(BUILD_COMMAND ./configure ${FFM_CONF}  --enable-libx265 --prefix=${EXTERN_INSTALL_DIR})
        else()
            set(BUILD_COMMAND ./configure --enable-shared --enable-static --prefix=${EXTERN_INSTALL_DIR})
        endif()
        EXECUTE_PROCESS(
                COMMAND ${BUILD_COMMAND}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ffmpeg RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        EXECUTE_PROCESS(
                COMMAND make -j
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ffmpeg RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        EXECUTE_PROCESS(
                COMMAND make install
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ffmpeg RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
    endif()
    # 查找ffmpeg
    set(FFMPEG_PATH_ROOT ${EXTERN_INSTALL_DIR})
#    # 查找 ffmpeg/libutil 是否安装
#    if(PKG_CONFIG_FOUND)
#        pkg_check_modules(AVUTIL QUIET IMPORTED_TARGET libavutil)
#        if(AVUTIL_FOUND)
#            update_cached_list(ZX_LINK_LIBRARIES PkgConfig::AVUTIL)
#            message(STATUS "found library: ${AVUTIL_LIBRARIES}")
#        endif()
#    endif()
#
#    # 查找 ffmpeg/libavcodec 是否安装
#    if(PKG_CONFIG_FOUND)
#        pkg_check_modules(AVCODEC QUIET IMPORTED_TARGET libavcodec)
#        if(AVCODEC_FOUND)
#            update_cached_list(ZX_LINK_LIBRARIES PkgConfig::AVCODEC)
#            message(STATUS "found library: ${AVCODEC_LIBRARIES}")
#        endif()
#    endif()
#
#    # 查找 ffmpeg/libswscale 是否安装
#    if(PKG_CONFIG_FOUND)
#        pkg_check_modules(SWSCALE QUIET IMPORTED_TARGET libswscale)
#        if(SWSCALE_FOUND)
#            update_cached_list(ZX_LINK_LIBRARIES PkgConfig::SWSCALE)
#            message(STATUS "found library: ${SWSCALE_LIBRARIES}")
#        endif()
#    endif()
#
#    # 查找 ffmpeg/libswresample 是否安装
#    if(PKG_CONFIG_FOUND)
#        pkg_check_modules(SWRESAMPLE QUIET IMPORTED_TARGET libswresample)
#        if(SWRESAMPLE_FOUND)
#            update_cached_list(ZX_LINK_LIBRARIES PkgConfig::SWRESAMPLE)
#            message(STATUS "found library: ${SWRESAMPLE_LIBRARIES}")
#        endif()
#    endif()
#
#    # 查找 ffmpeg/libavfilter 是否安装
#    if(PKG_CONFIG_FOUND)
#        pkg_check_modules(AVFILTER QUIET IMPORTED_TARGET libavfilter)
#        if(AVFILTER_FOUND)
#            update_cached_list(ZX_LINK_LIBRARIES PkgConfig::AVFILTER)
#            message(STATUS "found library: ${AVFILTER_LIBRARIES}")
#        endif()
#    endif()
#
#    # 查找 ffmpeg/libavformat 是否安装
#    if(PKG_CONFIG_FOUND)
#        pkg_check_modules(AVFORMAT QUIET IMPORTED_TARGET libavformat)
#        if(AVFORMAT_FOUND)
#            update_cached_list(ZX_LINK_LIBRARIES PkgConfig::AVFORMAT)
#            message(STATUS "found library: ${AVFORMAT_LIBRARIES}")
#        endif()
#    endif()
    #  pack mode
    # 查找 ffmpeg/libutil 是否安装
    find_package(AVUTIL REQUIRED)
    if(AVUTIL_FOUND)
        include_directories(SYSTEM ${AVUTIL_INCLUDE_DIR})
        update_cached_list(ZX_LINK_LIBRARIES ${AVUTIL_LIBRARIES})
        message(STATUS "found library: ${AVUTIL_LIBRARIES}")
    endif ()

    # 查找 ffmpeg/libavcodec 是否安装
    find_package(AVCODEC REQUIRED)
    if(AVCODEC_FOUND)
        include_directories(SYSTEM ${AVCODEC_INCLUDE_DIR})
        update_cached_list(ZX_LINK_LIBRARIES ${AVCODEC_LIBRARIES})
        message(STATUS "found library: ${AVCODEC_LIBRARIES}")
    endif()

    # 查找 ffmpeg/libswscale 是否安装
    find_package(SWSCALE REQUIRED)
    if(SWSCALE_FOUND)
        include_directories(SYSTEM ${SWSCALE_INCLUDE_DIR})
        update_cached_list(ZX_LINK_LIBRARIES ${SWSCALE_LIBRARIES})
        message(STATUS "found library: ${SWSCALE_LIBRARIES}")
    endif()

    # 查找 ffmpeg/libswresample 是否安装
    find_package(SWRESAMPLE REQUIRED)
    if(SWRESAMPLE_FOUND)
        include_directories(SYSTEM ${SWRESAMPLE_INCLUDE_DIRS})
        update_cached_list(ZX_LINK_LIBRARIES ${SWRESAMPLE_LIBRARIES})
        message(STATUS "found library: ${SWRESAMPLE_LIBRARIES}")
    endif()

    # 查找 ffmpeg/libavfilter 是否安装
    find_package(AVFILTER REQUIRED)
    if(AVFILTER_FOUND)
        include_directories(SYSTEM ${AVFILTER_INCLUDE_DIRS})
        update_cached_list(ZX_LINK_LIBRARIES ${AVFILTER_LIBRARIES})
        message(STATUS "found library: ${AVFILTER_LIBRARIES}")
    endif()

    # 查找 ffmpeg/libavformat 是否安装
    find_package(AVFORMAT REQUIRED)
    if(AVFORMAT_FOUND)
        include_directories(SYSTEM ${AVFORMAT_INCLUDE_DIRS})
        update_cached_list(ZX_LINK_LIBRARIES ${AVFORMAT_LIBRARIES})
        message(STATUS "found library: ${AVFORMAT_LIBRARIES}")
    endif()

    # 查找 ffmpeg/libpostproc 是否安装
    find_package(POSTPROC REQUIRED)
    if(POSTPROC_FOUND)
        include_directories(SYSTEM ${POSTPROC_INCLUDE_DIRS})
        update_cached_list(ZX_LINK_LIBRARIES ${POSTPROC_LIBRARIES})
        message(STATUS "found library: ${POSTPROC_LIBRARIES}")
    endif()

    if(AVUTIL_FOUND AND AVCODEC_FOUND AND SWSCALE_FOUND AND SWRESAMPLE_FOUND AND AVFILTER_FOUND AND AVFORMAT_FOUND AND POSTPROC_FOUND)
        update_cached_list(ZX_COMPILE_DEFINITIONS ENABLE_FFMPEG)
        update_cached_list(ZX_LINK_LIBRARIES ${CMAKE_DL_LIBS})
        if (FFMPEG_USE_STATIC_LIBS)
            update_cached_list(ZX_LINK_LIBRARIES)
        else()
            update_cached_list(ZX_LINK_LIBRARIES)
        endif()
    else()
        set(ENABLE_FFMPEG OFF)
        message(WARNING "ffmpeg 相关功能未找到")
    endif()
endif()