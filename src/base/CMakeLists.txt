#
# Created by HFauto on 2023/1/9.
# Copyright (c) 2023 HFauto. All rights reserved.
#
cmake_minimum_required(VERSION 3.12)
project(zx_base)

set(SRC_FILES
        zx_base.cpp
        zx_chn_base.cpp
        zx_plugin_base.cpp
        zx_plugin.cpp
        zx_process.cpp
        zx_system.cpp
        zx_thread_base.cpp
)

if (SRC_FILES)
    add_library(${PROJECT_NAME} OBJECT ${SRC_FILES})
    message(STATUS "add lib ${PROJECT_NAME}")
endif ()