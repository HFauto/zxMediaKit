#
# Created by HFauto on 2023/1/9.
# Copyright (c) 2023 HFauto. All rights reserved.
#
aux_source_directory(./ SRC_FILES)

add_executable(${PROJECT_NAME} ${SRC_FILES})
if (ENABLE_MEDIA_SERVICE_STATIC)
    target_link_libraries(${PROJECT_NAME} -Wl,--start-group ${PROJECT_NAME}_static -Wl,--end-group)
else()
    target_link_libraries(${PROJECT_NAME} -Wl,--start-group ${PROJECT_NAME}_shared -Wl,--end-group)
endif ()

add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})

install(
        TARGETS ${PROJECT_NAME}
        LIBRARY DESTINATION ${PROJECT_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${PROJECT_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${PROJECT_INSTALL_APPDIR}
        PUBLIC_HEADER DESTINATION ${PROJECT_INSTALL_INCDIR}
        PRIVATE_HEADER DESTINATION ${PROJECT_INSTALL_INCDIR}
        COMPONENT devel
)