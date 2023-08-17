# toolkit
cmake_minimum_required(VERSION 3.12)
project(zltoolkit)

set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
file(GLOB SRC_FILES ${ROOT_DIR}/*.cpp ${ROOT_DIR}/*.h ${ROOT_DIR}/*.c ${ROOT_DIR}/*/*.cpp ${ROOT_DIR}/*/*.h ${ROOT_DIR}/*/*.c)
if (NOT WIN32)
    list(REMOVE_ITEM SRC_FILES ${ROOT_DIR}/win32/getopt.c)
else ()
    add_definitions(-DWIN32_LEAN_AND_MEAN -DMP4V2_NO_STDINT_DEFS -D_CRT_SECURE_NO_WARNINGS -D_WINSOCK_DEPRECATED_NO_WARNINGS)
endif ()

if (SRC_FILES)
    add_library(${PROJECT_NAME} OBJECT ${SRC_FILES})
    message(STATUS "add lib ${PROJECT_NAME}")
endif ()

