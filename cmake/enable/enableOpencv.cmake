#
# Created by HFauto on 2022/12/26.
#
if(ENABLE_OPENCV)
    if(EXISTS "${EXTERN_INSTALL_DIR}/bin/setup_vars_opencv4.sh")
        message(STATUS "opencv exe exists")
    else()
        EXECUTE_PROCESS(
                COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/ RESULT_VARIABLE ret
        )
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv-4.7.0.tar.gz")
            message(STATUS "opencv zip exists")
            execute_process(
                    COMMAND tar -xzvf opencv-4.7.0.tar.gz
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
            )
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv-4.7.0")
                execute_process(
                        COMMAND mv ${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv-4.7.0 ${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
                        RESULT_VARIABLE ret
                )
                # 拷贝 pkg 文件，帮助opencv找到最新ffmpeg
                execute_process(
                        COMMAND cp -f ${CMAKE_CURRENT_SOURCE_DIR}/cmake/extern/ffmpeg-config.cmake ${CMAKE_CURRENT_SOURCE_DIR}/extern/usr/lib/cmake
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/
                        RESULT_VARIABLE ret
                )
            endif()
            if(NOT ret EQUAL 0)
                message(FATAL_ERROR "FAILED: ${ret}")
            endif()
        endif()
        #install
        if (ENABLE_OPENCV_STATIC)
            set(en_share -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON)
        else()
            set(en_share -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF)
        endif()
        set(CV_BUILD_COMMAND
#                -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-Bsymbolic # 告诉链接器遇到重名符号时优先链接本地符号
                -DCMAKE_BUILD_TYPE=Release
                ${en_share}
                -DBUILD_opencv_world=ON
                -DCMAKE_INSTALL_PREFIX=${EXTERN_INSTALL_DIR}
                -DWITH_FFMPEG=ON
                -DOPENCV_GENERATE_PKGCONFIG=ON
                -DOPENCV_FFMPEG_USE_FIND_PACKAGE=ON  # 通过find_package()查找ffmpeg
                -DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON
                -DCMAKE_PREFIX_PATH=${EXTERN_INSTALL_DIR}/lib/cmake #指定 ffmpeg-config.cmake所在目录
                -DFFMPEG_DIR=${EXTERN_INSTALL_DIR}  # 指定 lib include 目录前缀
                -DBUILD_TIFF=on             # 编译3rdparty/libtiff项目
                -DBUILD_JASPER=on           # 编译3rdparty/libjasper项目用于jpeg2000图像编解码
                -DBUILD_JPEG=on             # 编译3rdparty/libjpeg项目用于jpeg图像编解码
                -DBUILD_OPENEXR=on          # 编译3rdparty/openexr项目
                -DBUILD_PNG=on              # 编译3rdparty/libpng项目用于png图像编解码
                -DBUILD_TIFF=on             # 编译3rdparty/libtiff项目用于tiff图像编解码
                -DBUILD_ZLIB=on             # 编译3rdparty/zlib项目
                -DBUILD_opencv_apps=off     # 以下BUILD_opencv_XXXX选项用于选择或反选指定的opencv模块
                -DWITH_QUIRC=OFF
                -DWITH_PROTOBUF=OFF
                -DBUILD_PROTOBUF=OFF
                -DWITH_IPP=OFF
                -DBUILD_opencv_python3=OFF
                -DBUILD_opencv_python2=OFF
                -DBUILD_DOCS=off
                -DBUILD_FAT_JAVA_LIB=off
                -DBUILD_TESTS=off
                -DBUILD_opencv_calib3d=off
                -DBUILD_opencv_contrib=off
                -DBUILD_opencv_features2d=off
                -DBUILD_opencv_flann=off
                -DBUILD_opencv_gpu=off
                -DBUILD_opencv_dnn=off
                -DBUILD_opencv_java=off
                -DBUILD_opencv_legacy=off
                -DBUILD_opencv_ml=off
                -DBUILD_opencv_nonfree=on
                -DBUILD_opencv_objdetect=off
                -DBUILD_opencv_ocl=off
                -DBUILD_opencv_photo=off
                -DBUILD_opencv_python=off
                -DBUILD_opencv_stitching=off
                -DBUILD_opencv_superres=off
                -DBUILD_opencv_ts=off
                -DBUILD_opencv_video=off
                -DBUILD_opencv_videostab=off
                -DBUILD_opencv_lengcy=off
                -DWITH_1394=off
                -DWITH_EIGEN=off
                -DWITH_GIGEAPI=off
                -DWITH_GSTREAMER=off
                -DWITH_GTK=off
                -DWITH_PVAPI=off
                -DWITH_V4L=off
                -DWITH_LIBV4L=off
                -DWITH_CUDA=off
                -DWITH_CUFFT=off
                -DWITH_OPENCL=off
                -DWITH_OPENCLAMDBLAS=off
                -DWITH_OPENCLAMDFFT=off
        )
        execute_process(
                COMMAND cmake -S . -B build ${CV_BUILD_COMMAND}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        execute_process(
                COMMAND make -j${BUILD_CPU_NUM}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv/build RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
        execute_process(
                COMMAND make install
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern/opencv/build RESULT_VARIABLE ret)
        if(NOT ret EQUAL 0)
            message(FATAL_ERROR "FAILED: ${ret}")
        endif()
    endif()
     # 更新cmake find文件
    if (ENABLE_OPENCV_STATIC)
        execute_process(
                COMMAND cp -f ${CMAKE_SOURCE_DIR}/cmake/extern/OpenCVConfig-static.cmake ${CMAKE_SOURCE_DIR}/extern/usr/lib/cmake/opencv4/OpenCVConfig.cmake
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                RESULT_VARIABLE ret
        )
    else()
        execute_process(
                COMMAND cp -f ${CMAKE_SOURCE_DIR}/cmake/extern/OpenCVConfig-shared.cmake ${CMAKE_SOURCE_DIR}/extern/usr/lib/cmake/opencv4/OpenCVConfig.cmake
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                RESULT_VARIABLE ret
        )
    endif()
    set(OpenCV_DIR ${EXTERN_INSTALL_DIR})
    find_package(OpenCV REQUIRED)
    message(STATUS "find opencv version: ${OpenCV_VERSION}")
    message(STATUS "find opencv library: ${OpenCV_LIBRARIES}")
    # link
    update_cached_list(ZX_LINK_LIBRARIES ${OpenCV_LIBRARIES})
endif ()