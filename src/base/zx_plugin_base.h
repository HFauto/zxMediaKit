//
// Created by HFauto on 2022/7/11.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#ifndef ZXAISERVICE_ZXPLUGINBASE_H
#define ZXAISERVICE_ZXPLUGINBASE_H

#include "zx_base.h"

class zxPluginBase: public zxBase{
public:
    using Ptr = std::shared_ptr<zxPluginBase>;
    zxPluginBase()=default;
    ~zxPluginBase()=default;
};

#endif //ZXAISERVICE_ZXPLUGINBASE_H
