//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#ifndef ZXSJVIDEOCODECAPP_THREADSAFEDEQUE_H
#define ZXSJVIDEOCODECAPP_THREADSAFEDEQUE_H
#include <string>
#include <iostream>
#include <deque>
#include <atomic>
#include <thread>

template<class T>
class zxThreadSafeDeque {
public:
    zxThreadSafeDeque():bufferSize(200),ato_write_flag(false){}
    explicit zxThreadSafeDeque(int max):bufferSize(max),ato_write_flag(false){}
    int push_front(const std::shared_ptr<T> &value){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() < bufferSize){
            queueBuffer.push_front(value);
        }else{
            ret = -1;
        }
        ato_write_flag.clear();
        return ret;
    }
    /**
     * 先入先出循环buf
     * @param value
     * @return
     */
    int push_front_cycle(const std::shared_ptr<T> &value){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() < bufferSize){
            queueBuffer.push_front(value);
        }else{
            queueBuffer.pop_back();
            queueBuffer.push_front(value);
        }
        ato_write_flag.clear();
        return ret;
    }

    int push_back(const std::shared_ptr<T> &value){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() < bufferSize){
            queueBuffer.push_back(value);
        }else{
            ret = -1;
        }
        ato_write_flag.clear();
        return ret;
    }
    /**
     * 先入先出循环buf
     * @param value
     * @return
     */
    int push_back_cycle(const std::shared_ptr<T> &value){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() < bufferSize){
            queueBuffer.push_back(value);
        }else{
            queueBuffer.pop_front();
            queueBuffer.push_back(value);
        }
        ato_write_flag.clear();
        return ret;
    }

    std::shared_ptr<T> pop_front(){
        std::shared_ptr<T> value = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() != 0){
            value = queueBuffer.front();
            queueBuffer.pop_front();
        }
        ato_write_flag.clear();
        return value;
    }

    std::shared_ptr<T> pop_back(){
        std::shared_ptr<T> value = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        if(queueBuffer.size() != 0){
            value = queueBuffer.back();
            queueBuffer.pop_back();
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
    int getMaxSize(){
        int ret = 0;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        ret = bufferSize;
        ato_write_flag.clear();
        return bufferSize;
    }
    void clear(){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        while (!queueBuffer.empty()) queueBuffer.pop_back();
        ato_write_flag.clear();
    }
private:
    int bufferSize = 200;
    std::atomic_flag ato_write_flag;
    std::deque<std::shared_ptr<T>> queueBuffer;
};


#endif //ZXSJVIDEOCODECAPP_THREADSAFEDEQUE_H
