//
// Created by HFauto on 2022/12/29.
//
#ifdef ENABLE_FFMPEG
#ifdef __cplusplus
extern "C" {
#endif
#include <stdio.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfilter.h>
#include <libavutil/log.h>
#ifdef __cplusplus
}
#endif

int main(int argc, char *argv[]){
    av_log_set_level(AV_LOG_DEBUG);
    av_log(nullptr,AV_LOG_INFO,"%s\n","hello world");
    return 0;
}

#else
#include <cstdio>
int main(int argc, char *argv[]) {
    printf("The compile option for this test is not turned on\n");
}
#endif