//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#ifndef ZXSJVIDEOCODECAPP_THREADSAFEQUEUE_H
#define ZXSJVIDEOCODECAPP_THREADSAFEQUEUE_H
#include <string>
#include <iostream>
#include <queue>
#include <atomic>
#include <thread>

template<class T>
class zxThreadSafeQueue {
public:
    zxThreadSafeQueue():bufferSize(200),ato_write_flag(false){}
    explicit zxThreadSafeQueue(int max):bufferSize(max),ato_write_flag(false){}
    int push(const std::shared_ptr<T> &value){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() < bufferSize){
            queueBuffer.push(value);
        }else{
            ret = -1;
        }
        ato_write_flag.clear();
        return ret;
    }
    std::shared_ptr<T> pop(){
        std::shared_ptr<T> value = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() != 0){
            value = queueBuffer.front();
            queueBuffer.pop();
        }
        ato_write_flag.clear();
        return value;
    }

    std::shared_ptr<T> front(){
        std::shared_ptr<T> value = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() != 0){
            value = queueBuffer.front();
        }
        ato_write_flag.clear();
        return value;
    }

    std::shared_ptr<T> back(){
        std::shared_ptr<T> value = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() != 0){
            value = queueBuffer.back();
        }
        ato_write_flag.clear();
        return value;
    }
    bool empty(){
        bool ret = false;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        ret = queueBuffer.empty();
        ato_write_flag.clear();
        return ret;
    }
    bool full(){
        bool ret = false;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        ret = (queueBuffer.size() == bufferSize);
        ato_write_flag.clear();
        return ret;
    }
    int size(){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        ret = queueBuffer.size();
        ato_write_flag.clear();
        return ret;
    }
    int setMaxSize(int size){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        bufferSize = size;
        ato_write_flag.clear();
        return ret;
    }
    void clear(){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        while (queueBuffer.size()) queueBuffer.pop();
        ato_write_flag.clear();
    }
private:
    int bufferSize = 200;
    std::atomic_flag ato_write_flag;
    std::queue<std::shared_ptr<T>> queueBuffer;
};


#endif //ZXSJVIDEOCODECAPP_THREADSAFEQUEUE_H
