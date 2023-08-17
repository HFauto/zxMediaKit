//
// Created by HFauto on 2022/7/21.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#ifndef ZXAISERVICE_ZXCHNBASE_H
#define ZXAISERVICE_ZXCHNBASE_H

#include "zx_base.h"
class zxChnInfo{
public:
    typedef std::shared_ptr<zxChnInfo> Ptr;
    zxChnInfo(int gop, int chn):group(gop),channel(chn){}
    int group = 0;
    int channel = 0;
};
/**
 * 为继承者提供通道复用功能
 */
class zxChnBase {
public:
    zxChnBase()=default;
    ~zxChnBase()=default;
    int initChannel(int maxGroup, int maxChn);
    int setDecodeChannel(zxChnInfo::Ptr chnInfo);
    int setChannel(zxChnInfo::Ptr chnInfo);
    int getChannelSize();
    zxChnInfo::Ptr getDecodeChannel();
    zxChnInfo::Ptr getChannel();
    //存放自己解码/编码通道
    zxChnInfo::Ptr _chn;
private:
    //存放全局解码/编码通道
    zxThreadSafeVector<zxChnInfo> _gChn;
};


#endif //ZXAISERVICE_ZXCHNBASE_H
