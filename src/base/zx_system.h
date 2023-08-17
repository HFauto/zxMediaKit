//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//


#ifndef ZLMEDIAKIT_SYSTEM_H
#define ZLMEDIAKIT_SYSTEM_H

#include <string>
using namespace std;

class System {
public:
    static string execute(const string &cmd);
    static void startDaemon();
    static void systemSetup(bool enCore = false);
};

#endif //ZLMEDIAKIT_SYSTEM_H
