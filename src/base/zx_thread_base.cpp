//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#include "zx_thread_base.h"
/**
 * 回收线程
 */
zxThreadBase::~zxThreadBase() {
    if (_pThread){
        _pThread->join();
        _pThread = nullptr;
    }
    if (_pThread2){
        _pThread2->join();
        _pThread2 = nullptr;
    }
    if (_pThread3){
        _pThread3->join();
        _pThread3 = nullptr;
    }
}
/**
 * 启动任务
 * @param ptr
 * @return
 */
int zxThreadBase::start() {
    int ret,ret2,ret3;
    ret = runTask();
    ret2 = runTask2();
    ret3 = runTask3();
    if (ret==0 && ret2==0 && ret3==0){
        return 0;
    }else{
        return -1;
    }
}
/**
 * 停止任务
 * @return
 */
int zxThreadBase::stop() {
    int ret,ret2,ret3;
    ret = stopTask();
    ret2 = stopTask2();
    ret3 = stopTask3();
    if (ret==0 && ret2==0 && ret3==0){
        return 0;
    }else{
        return -1;
    }
}
/**
 * 启动线程
 * @return
 */
int zxThreadBase::runTask() {
    if (_enTask.load()){
        return -1;
    }
    _enTask.store(true);
    if (!_pThread){
        _pThread = make_shared<thread>(&zxThreadBase::runTaskProc,this);
    }
    return 0;
}
/**
 * 启动线程2
 * @return
 */
int zxThreadBase::runTask2() {
    if (_enTask2.load()){
        return -1;
    }
    _enTask2.store(true);
    if (!_pThread2){
        _pThread2 = make_shared<thread>(&zxThreadBase::runTaskProc2,this);
    }
    return 0;
}
/**
 * 启动线程3
 * @return
 */
int zxThreadBase::runTask3() {
    if (_enTask3.load()){
        return -1;
    }
    _enTask3.store(true);
    if (!_pThread3){
        _pThread3 = make_shared<thread>(&zxThreadBase::runTaskProc3,this);
    }
    return 0;
}
/**
 * 停止线程
 * @return
 */
int zxThreadBase::stopTask() {
    if (!_enTask){
        return -1;
    }
    _enTask.store(false);
    _pThread->join();
    _pThread = nullptr;
    return 0;
}
/**
 * 停止线程2
 * @return
 */
int zxThreadBase::stopTask2() {
    if (!_enTask2){
        return -1;
    }
    _enTask2.store(false);
    _pThread2->join();
    _pThread2 = nullptr;
    return 0;
}
/**
 * 停止线程3
 * @return
 */
int zxThreadBase::stopTask3() {
    if (!_enTask3){
        return -1;
    }
    _enTask3.store(false);
    _pThread3->join();
    _pThread3 = nullptr;
    return 0;
}
/**
 * 线程服务函数
 * @return
 */
int zxThreadBase::runTaskProc() {
    while (_enTask.load()){
        // do something
        _enTask.store(false);
    }
    return 0;
}
/**
 * 线程服务函数2
 * @return
 */
int zxThreadBase::runTaskProc2() {
    while (_enTask2.load()){
        // do something
        _enTask2.store(false);
    }
    return 0;
}
/**
 * 线程服务函数3
 * @return
 */
int zxThreadBase::runTaskProc3() {
    while (_enTask3.load()){
        // do something
        _enTask3.store(false);
    }
    return 0;
}


