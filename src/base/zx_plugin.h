//
// Created by HFauto on 2022/7/12.
// Copyright (c) 2022 HFauto. All rights reserved.
//

#ifndef ZXAISERVICE_ZXPLUGIN_H
#define ZXAISERVICE_ZXPLUGIN_H

#include "zx_base.h"
#include "zx_plugin_base.h"

using zxPluginType = zxThreadSafeMap<string ,zxPluginBase>;
using zxPluginPtr = shared_ptr<zxPluginType>;
/**
 *  各模块应继承此类提供的插件基础功能
 */
class zxPlugin: public zxPluginBase{
public:
    using Ptr = std::shared_ptr<zxPlugin>;
    //应用于向下传递插件
    explicit zxPlugin(zxPluginType *plugin):gPlugins(plugin){};
    explicit zxPlugin(zxPluginType &plugin):gPlugins(&plugin){};
    zxPlugin()=default;
    ~zxPlugin()=default;
    zxPluginBase::Ptr addParentPlugin(const string &pluginName, const zxPluginBase::Ptr& plugin){return gPlugins->find_and_insert(pluginName, plugin);};
    zxPluginBase::Ptr addSelfPlugin(const string &pluginName, const zxPluginBase::Ptr& plugin){return plugins.find_and_insert(pluginName, plugin);};
    zxPluginBase::Ptr delParentPlugin(const string &pluginName){return gPlugins->find_and_remove(pluginName);};
    zxPluginBase::Ptr delSelfPlugin(const string &pluginName){return plugins.find_and_remove(pluginName);};
    zxPluginBase::Ptr getParentPlugin(const string &pluginName){return gPlugins->find(pluginName);};
    zxPluginBase::Ptr getSelfPlugin(const string &pluginName){return plugins.find(pluginName);};
    void cleanParentPlugin() {gPlugins->clear();};
    void cleanSelfPlugin(){plugins.clear();};
    //用于存放来自上层的插件组
    zxPluginType *gPlugins{};
    //用于存放继承者自己的插件组
    zxPluginType plugins;
    // 此插件被引用的次数(当引用次数为0时此插件需要被删除)
    std::atomic_int reference{0};

};

#endif //ZXAISERVICE_ZXPLUGIN_H
