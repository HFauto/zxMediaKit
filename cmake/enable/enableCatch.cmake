#
# Created by HFauto on 2022/12/26.
#

# 下载catch测试单元
if(ENABLE_CATCH)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/catch/tools")
        message(STATUS "catch src exists")
        FetchContent_Declare(
                catch
                SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/catch)
        FetchContent_MakeAvailable(catch)
    else()
        FetchContent_Declare(
                catch
                URL ${CMAKE_CURRENT_SOURCE_DIR}/extern/Catch2-3.2.1.tar.gz
                URL_HASH  MD5=103C2BBD9B3B781605800158BC0E33E6
                SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/catch)
        FetchContent_MakeAvailable(catch)
#        FetchContent_Declare(
#                catch
#                GIT_REPOSITORY https://github.com/catchorg/Catch2.git
#                GIT_TAG v2.13.6
#                SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/catch)
#        FetchContent_MakeAvailable(catch)
    endif()
    list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/extras)
    update_cached_list(MK_COMPILE_DEFINITIONS ENABLE_CATCH)
    update_cached_list(ZX_LINK_LIBRARIES Catch2::Catch2WithMain)
endif()