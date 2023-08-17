#
# Created by HFauto on 2022/12/29.
# Copyright (c) 2023 HFauto. All rights reserved.
#
cmake_minimum_required(VERSION 3.12)

install(
        PROGRAMS run.sh stop.sh test.sh
        DESTINATION ${PROJECT_INSTALL_ROOTDIR}
        COMPONENT devel
)