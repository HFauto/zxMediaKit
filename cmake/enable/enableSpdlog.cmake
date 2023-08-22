#
# Created by HFauto on 2022/12/26.
#

# 下载spdlog
if(ENABLE_SPDLOG)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/spdlog/src")
        message(STATUS "spdlog src exists")
        FetchContent_Declare(
                spdlog
                SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/spdlog)
        FetchContent_MakeAvailable(spdlog)
    else()
        FetchContent_Declare(
                spdlog
                URL ${CMAKE_CURRENT_SOURCE_DIR}/extern/spdlog-1.11.0.tar.gz
                URL_HASH  MD5=287C6492C25044FD2DA9947AB120B2BD
                SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/spdlog)
        FetchContent_MakeAvailable(spdlog)
#        FetchContent_Declare(
#                spdlog
#                GIT_REPOSITORY https://github.com/gabime/spdlog.git
#                GIT_TAG v1.x
#                SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/spdlog)
#        FetchContent_MakeAvailable(spdlog)
    endif()
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/extern/catch/include)
    update_cached_list(MK_COMPILE_DEFINITIONS ENABLE_CATCH)
    update_cached_list(ZX_LINK_LIBRARIES spdlog::spdlog)
endif()