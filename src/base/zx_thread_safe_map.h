//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//
#ifndef ZXSJVIDEOCODECAPP_THREADSAFEMAP_H
#define ZXSJVIDEOCODECAPP_THREADSAFEMAP_H
#include <string>
#include <iostream>
#include <map>
#include <atomic>
#include <thread>
#include <vector>

template<class K, class V>
class zxThreadSafeMap {
public:
    zxThreadSafeMap():ato_write_flag(false){}

    int insert(K key, const std::shared_ptr<V> &data){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        auto it = mapBuffer.find(key);
        if(it == mapBuffer.end()){
            mapBuffer.insert(std::make_pair(key, data));
        }
        ato_write_flag.clear();
        return 0;
    }

    std::shared_ptr<V> find(const K& key){
        std::shared_ptr<V> value = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        auto it = mapBuffer.find(key);
        if(it != mapBuffer.end()){
            value = it->second;
        }

        ato_write_flag.clear();
        return value;
    }

    std::shared_ptr<V> find_and_insert(const K& key, const std::shared_ptr<V> &value){
        std::shared_ptr<V> tmp = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        auto it = mapBuffer.find(key);
        if(it != mapBuffer.end()){
            tmp = it->second;
        }else{
            mapBuffer.template insert(std::make_pair(key, value));
        }
        ato_write_flag.clear();
        return tmp;
    }

    int remove(const K& key){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        auto it = mapBuffer.find(key);
        if(it != mapBuffer.end()){
            mapBuffer.erase(it);
        }
        ato_write_flag.clear();
        return 0;
    }

    std::shared_ptr<V> find_and_remove(const K& key){
        std::shared_ptr<V> tmp = nullptr;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        auto it = mapBuffer.find(key);
        if(it != mapBuffer.end()){
            tmp = it->second;
            mapBuffer.erase(it);
        }
        ato_write_flag.clear();
        return tmp;
    }

    int size(){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        int size =mapBuffer.size();
        ato_write_flag.clear();
        return size;
    }

    bool empty(){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        bool size =mapBuffer.empty();
        ato_write_flag.clear();
        return size;
    }

    void clear(){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        mapBuffer.clear();
        ato_write_flag.clear();
    }

    int update(const K& key,std::shared_ptr<V> data){
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        auto it = mapBuffer.find(key);
        if(it != mapBuffer.end()){
            it->second = data;
        }
        ato_write_flag.clear();
        return 0;
    }

    std::vector<std::shared_ptr<V>> data(){
        std::vector<std::shared_ptr<V>> vec_data;
        while(ato_write_flag.test_and_set()){
            std::this_thread::yield();
        }
        auto it = mapBuffer.begin();
        for(it; it != mapBuffer.end(); it++){
            vec_data.push_back(it->second);
        }
        ato_write_flag.clear();
        return vec_data;
    }
private:
    std::atomic_flag ato_write_flag;
    std::map<K, std::shared_ptr<V>> mapBuffer;
};


#endif
