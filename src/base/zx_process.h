//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//


#ifndef ZLMEDIAKIT_PROCESS_H
#define ZLMEDIAKIT_PROCESS_H

#ifdef _WIN32
typedef int pid_t;
#else
#include <sys/wait.h>
#endif // _WIN32

#include <fcntl.h>
#include <string>
using namespace std;

class Process {
public:
    Process();
    ~Process();
    void run(const string &cmd,const string &log_file);
    void kill(int max_delay,bool force = false);
    bool wait(bool block = true);
    int exit_code();
private:
    pid_t _pid = -1;
    void *_handle = nullptr;
    int _exit_code = 0;
};


#endif //ZLMEDIAKIT_PROCESS_H
