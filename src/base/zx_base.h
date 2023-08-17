//
// Created by admin on 2022/7/12.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#ifndef ZXAISERVICE_ZXBASE_H
#define ZXAISERVICE_ZXBASE_H

#include "iostream"
#include "memory"
#include "sstream"
#include "thread"
#include "chrono"
#include "vector"
#include "map"
#include "deque"
#include "queue"
#include "mutex"
#include "zx_thread_safe_deque.h"
#include "zx_thread_safe_vector.h"
#include "zx_thread_safe_queue.h"
#include "zx_thread_safe_map.h"
using namespace std;

class zxBase {
public:
    zxBase()=default;
    ~zxBase()=default;
};


#endif //ZXAISERVICE_ZXBASE_H
