#
# Created by HFauto on 2022/12/26.
#

if(ENABLE_WORKFLOW)
    if(ENABLE_WORKFLOW_KAFKA)
        set(KAFKA "y")
        if(ENABLE_WORKFLOW_KAFKA_STATIC)
            update_cached_list(ZX_LINK_LIBRARIES wfkafka-static)
        else()
            update_cached_list(ZX_LINK_LIBRARIES wfkafka-shared)
        endif()
        include(${CMAKE_SOURCE_DIR}/cmake/enable/enableWorkflowKafka.cmake)
    else()
        set(KAFKA "n")
    endif()

    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/workflow/benchmark")
        message(STATUS "workflow src exists")
        FetchContent_Declare(
                workflow
                SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/workflow)
        FetchContent_MakeAvailable(workflow)
    else()
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/extern/workflow-master.zip")
            message(STATUS "workflow zip exists")
            FetchContent_Declare(
                    workflow
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/extern/workflow-master.zip
                    URL_HASH  MD5=c85fec73f7e8faf865c5b6dd49b05935
                    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/workflow)
            FetchContent_MakeAvailable(workflow)
        else()
            FetchContent_Declare(
                    workflow
                    GIT_REPOSITORY https://github.com/sogou/workflow.git
                    GIT_TAG master
                    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extern/workflow)
            FetchContent_MakeAvailable(workflow)
        endif()
    endif()
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/extern/workflow/src/include)
    update_cached_list(MK_COMPILE_DEFINITIONS ENABLE_WORKFLOW)
    if (ENABLE_WORKFLOW_STATIC)
        update_cached_list(ZX_LINK_LIBRARIES workflow-static)
    else()
        update_cached_list(ZX_LINK_LIBRARIES workflow-shared)
    endif ()
endif()