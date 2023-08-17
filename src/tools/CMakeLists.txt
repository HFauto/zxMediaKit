#
# Created by HFauto on 2023/1/9.
# Copyright (c) 2023 HFauto. All rights reserved.
#
cmake_minimum_required(VERSION 3.12)
project(zx_tools)

set(SRC_FILES
        zx_cv_tools.cpp
        zx_ffm_tools.cpp
        zx_yuv_tools.cpp
)

if (SRC_FILES)
    add_library(${PROJECT_NAME} OBJECT ${SRC_FILES})
    message(STATUS "add lib ${PROJECT_NAME}")
endif ()