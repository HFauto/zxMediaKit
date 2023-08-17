#
# Created by HFauto on 2023/1/9.
# Copyright (c) 2023 HFauto. All rights reserved.
#
cmake_minimum_required(VERSION 3.12)
project(zx_ffmcpp)

set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
file(GLOB SRC_FILES ${ROOT_DIR}/*.cpp ${ROOT_DIR}/*.h ${ROOT_DIR}/*.c ${ROOT_DIR}/*/*.cpp ${ROOT_DIR}/*/*.h ${ROOT_DIR}/*/*.c)

if (SRC_FILES)
    add_library(${PROJECT_NAME} OBJECT ${SRC_FILES})
    message(STATUS "add lib ${PROJECT_NAME}")
endif ()

