//
// Created by HFauto on 2022/7/21.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#include "zx_chn_base.h"
/**
 *
 * @param maxGroup  最大组数
 * @param maxChn 每组最大通道数
 * @return all 0
 */
int zxChnBase::initChannel(int maxGroup, int maxChn){
    for (int i = 0; i < maxGroup; ++i) {
        for (int j = 0; j < maxChn; ++j) {
            _gChn.push_back(std::make_shared<zxChnInfo>(i,j));
        }
    }
    return 0;
}
/**
 * 获取一个有效得通道 并从可用通道组中删除此通道
 * @return zxChnInfo
 */
zxChnInfo::Ptr zxChnBase::getDecodeChannel() {
    auto chn = _gChn.back();
    _gChn.pop_back();
    return chn;
}

/**
 * 获取一个有效得通道 并从可用通道组中删除此通道
 * @return zxChnInfo
 */
zxChnInfo::Ptr zxChnBase::getChannel() {
    auto chn = _gChn.back();
    _gChn.pop_back();
    return chn;
}

/**
 * 归还通道 方便复用
 * @return all 0
 */
int zxChnBase::setDecodeChannel(zxChnInfo::Ptr chnInfo) {
    _gChn.push_back(std::move(chnInfo));
    return 0;
}
/**
 * 归还通道 方便复用
 * @return all 0
 */
int zxChnBase::setChannel(zxChnInfo::Ptr chnInfo) {
    _gChn.push_back(std::move(chnInfo));
    return 0;
}
/**
 * 获取剩余通道数量
 * @return 剩余通道数量
 */
int zxChnBase::getChannelSize() {
    return _gChn.size();
}
