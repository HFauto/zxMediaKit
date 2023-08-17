//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#ifndef ZXAISERVICE_ZXTHREADBASE_H
#define ZXAISERVICE_ZXTHREADBASE_H

#include "zx_base.h"
/**
 *  提供多线程基础功能
 */
class zxThreadBase {
public:
    zxThreadBase()=default;
    ~zxThreadBase();
    virtual int start();
    virtual int stop();

protected:
    virtual int runTask();
    virtual int stopTask();

    virtual int runTaskProc();
    virtual int runTask2();
    virtual int stopTask2();
    virtual int runTaskProc2();
    virtual int runTask3();
    virtual int stopTask3();
    virtual int runTaskProc3();

    shared_ptr<thread> _pThread;
    std::atomic_bool   _enTask{false};
    shared_ptr<thread> _pThread2;
    std::atomic_bool   _enTask2{false};
    shared_ptr<thread> _pThread3;
    std::atomic_bool   _enTask3{false};
};


#endif //ZXAISERVICE_ZXTHREADBASE_H
