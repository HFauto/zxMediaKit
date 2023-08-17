# zxMediaService

[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://111.160.23.206:8081/mediakit/mediakit/-/tree/master/LICENSE)
[![Language](https://img.shields.io/badge/language-c++14-red.svg)](https://en.cppreference.com/)
[![Platform](https://img.shields.io/badge/platform-linux%20-yellow.svg)](https://www.kernel.org/)
[![author](https://img.shields.io/badge/author-HFauto%20-y.svg)]()

用于快速搭建一个流媒体开发基础环境

[toc]

### 编译环境
  + 基础编译环境
    ~~~shell
    sudo apt-get install build-essential cmake zlib1g-dev liblzma-dev libz2-dev nasm
    ~~~

  + 要求 cmake 版本 3.12 及以上，升级方法
      ~~~shell
      sudo ./extern/cmake-3.25.1-linux-x86_64.sh -- --skip-license --prefix=/usr
      sudo ./extern/cmake-3.24.3-linux-aarch64.sh -- --skip-license --prefix=/usr
      ~~~

  + 如果更新 extern 中 libyuv 源码，则需要在原 libyuv 的 CmakeList.txt 中添加
      ~~~cmake
      CMAKE_MINIMUM_REQUIRED( VERSION 3.12 )
      set(CMAKE_C_STANDARD 11)
      set(CMAKE_CXX_STANDARD 11)
      if(POLICY CMP0064)
      cmake_policy(SET CMP0064 NEW)
      endif()
      set(EXTERN_INSTALL_DIR      ${CMAKE_CURRENT_SOURCE_DIR}/../usr)
      set(JPEG_PATH_ROOT ${EXTERN_INSTALL_DIR})
      set(JPEG_DIR ${EXTERN_INSTALL_DIR})
      ~~~
  + 如果更新了 opencv 源码,需要更改 /cmake/extern/OpenCVConfig-xxx 文件中的版本信息
    ~~~shell
        # 为方便使用cmake查找链接opencv_world，opencv编译完成后替换了原有的config文件
        cp -f ${CMAKE_SOURCE_DIR}/cmake/extern/OpenCVConfig-static.cmake ${CMAKE_SOURCE_DIR}/extern/usr/lib/cmake/opencv4/OpenCVConfig.cmake
        cp -f ${CMAKE_SOURCE_DIR}/cmake/extern/OpenCVConfig-shared.cmake ${CMAKE_SOURCE_DIR}/extern/usr/lib/cmake/opencv4/OpenCVConfig.cmake
    ~~~
  + 注意事项
    + 使用 workflow 组件时不允许使用 jemalloc 组件。
    
    + ffmpeg 与 opencv 组件同时使用时，避免与系统本身自带的 ffmpeg 库冲突，
      需要 cmake/extern/ffmpeg-config.cmake 帮助找到我们编译的 ffmpeg 而不是系统本身的，
      构建时会自动拷贝到 EXTERN_INSTALL_DIR 目录，
      注意：当更换 ffmpeg 源码时需要修改 ffmpeg-config.cmake 中的版本信息。

    + 所支持的组件全部支持动态或静态链接到主服务，
      静态链接耗时较长，主程序体积较大，但是部署更加方便，根据实际业务灵活选用。
    + 使用动态编译时：所使能的第三方库全部安装在 extern/usr 下面，部署程序时按需拷贝。
    + make install 后程序安装目录为 release/xxx。
    + 某个组件需要重新编译时：
    删除 extern/usr/bin/xxx 中对应程序后重新构建即可，cmake将重新删除组件原来的构建目录重新构建编译。

### 快速开始
  ~~~sh
  # 初次构建时需要安装依赖用时较长，按需开启编译选项
  clone http://111.160.23.206:8081/mediakit/mediakit.git 
  cd mediakit
  mkdir build && cd build && cmake .. && make -j && make install -j
  ~~~

### 编译选项
  ~~~shell
    -- ENABLE_CATCH                    ON
    -- ENABLE_SPDLOG                   ON
    -- ENABLE_JEMALLOC                 OFF
    -- ENABLE_JEMALLOC_STATIC          OFF
    -- ENABLE_OPENSSL                  ON
    -- ENABLE_OPENSSL_STATIC           ON
    -- ENABLE_LIBYUV                   ON
    -- ENABLE_LIBYUV_STATIC            ON
    -- ENABLE_X264                     ON
    -- ENABLE_X264_STATIC              ON
    -- ENABLE_X265                     ON
    -- ENABLE_X265_STATIC              ON
    -- ENABLE_FFMPEG                   ON
    -- ENABLE_FFMPEG_STATIC            ON
    -- ENABLE_OPENCV                   ON
    -- ENABLE_OPENCV_STATIC            ON
    -- ENABLE_WORKFLOW                 ON
    -- ENABLE_WORKFLOW_STATIC          ON
    -- ENABLE_WORKFLOW_KAFKA           ON
    -- ENABLE_WORKFLOW_KAFKA_STATIC    ON
    -- ENABLE_BUILD_TEST               ON
    -- ENABLE_MEDIA_SERVICE_STATIC     ON
  ~~~

### 目录结构
~~~shell
.
├── app # 可执行程序
├── bash # 脚本工具
├── cmake # 自定义cmake模块
│   ├── checks 
│   ├── enable 
│   ├── find
│   └── func
├── docs # Sphinx文档构建
│   ├── build           
│   ├── doc           
│   └── html
├── extern # 三方库
│   ├── catch
│   ├── external-Linux
│   ├── ffmpeg
│   ├── opencv
│   ├── libjpeg
│   ├── libx264
│   ├── libx265
│   ├── libyuv
│   ├── lz4
│   ├── openssl
│   ├── spdlog
│   ├── usr # 所有三方依赖库的安装路径
│   │   ├── bin
│   │   ├── include
│   │   └── lib
│   ├── workflow
│   └── zstd
├── release # 程序安装路径
├── lib # 项目库
├── src # 项目源码
│   ├── base # 基础库
│   ├── ffmcpp # 对ffmpeg的cpp二次封装
│   ├── include # 头文件
│   ├── log # 自定义日志模块
│   ├── main # 主程序入口
│   ├── toolkit #zltoolkit模块
│   ├── tools # 对三方库的二次封装或其他工具库
│   └── util  #通用函数库
└── test  # 包含各模块的test程序

~~~
### 三方库文档
[文档](./some_tutorials.md)
