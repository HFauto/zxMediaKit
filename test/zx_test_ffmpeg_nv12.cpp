//
// Created by HFauto on 2022/12/30.
//
#ifdef ENABLE_FFMPEG
#ifdef __cplusplus
extern "C" {
#endif
#include <stdio.h>
#include <stdlib.h>
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavdevice/avdevice.h"
#include "libavutil/opt.h"
#include "libavfilter/avfilter.h"
#include "libavfilter/buffersrc.h"
#include "libavfilter/buffersink.h"
#include "libavutil/imgutils.h"
#include <libavutil/log.h>
#ifdef __cplusplus
}
#endif

///*
//srcBuffer：源yuv数据
//srcWidth：宽
//srcHeight：高
//dstBuffer：目标buffer
//dstWidth：目标宽
//dstHeight：目标高
//offestX：起始x坐标
//offsetY：起始y坐标
//format：YUV数据的格式，例如AV_PIX_FMT_NV12 AV_PIX_FMT_NV21 AV_PIX_FMT_YUV420P
//*/
//int32_t Crop(uint8_t* srcBuffer, uint32_t srcWidth, uint32_t srcHeight,
//             uint8_t* dstBuffer, uint32_t dstWidth, uint32_t dstHeight,
//             uint32_t offsetX, uint32_t offsetY, AVPixelFormat format) {
//    // 创建AVFrame
//    AVFrame* srcFrame = av_frame_alloc();
//    srcFrame->width = srcWidth;
//    srcFrame->height = srcHeight;
//    srcFrame->format = format;
//    // 填充AVFrame
//    av_image_fill_arrays(srcFrame->data, srcFrame->linesize, srcBuffer, format, srcWidth, srcHeight, 1);
//    AVFrame* dstFrame = av_frame_alloc();
//    // 进行crop
//    AVFilterGraph* filterGraph = avfilter_graph_alloc();
//    char args[512] = "";
//    snprintf(args, sizeof(args),
//             "buffer=video_size=%dx%d:pix_fmt=%d:time_base=1/1:pixel_aspect=1/1[in];" // Parsed_buffer_0
//             "[in]crop=x=%d:y=%d:out_w=%d:out_h=%d[out];"                             // Parsed_crop_1
//             "[out]buffersink",                                                       // Parsed_buffersink_2
//             srcWidth, srcHeight, format,
//             offsetX, offsetY, dstWidth, dstHeight);
//
//    AVFilterInOut* inputs = NULL;
//    AVFilterInOut* outputs = NULL;
//    avfilter_graph_parse2(filterGraph, args, &inputs, &outputs);
//    avfilter_graph_config(filterGraph, NULL);
//    AVFilterContext* srcFilterCtx = avfilter_graph_get_filter(filterGraph, "Parsed_buffer_0");
//    AVFilterContext* sinkFilterCtx = avfilter_graph_get_filter(filterGraph, "Parsed_buffersink_2");
//
//    dstFrame = av_frame_clone(srcFrame);
//    av_buffersrc_add_frame(srcFilterCtx, dstFrame);
//    av_buffersink_get_frame(sinkFilterCtx, dstFrame);
//    avfilter_graph_free(&filterGraph);
//
//    // 获取crop完成后的数据
//    avpicture_layout(dstFrame, format, dstWidth, dstHeight, dstBuffer, av_image_get_buffer_size(format, dstWidth, dstHeight,0));
//    av_frame_free(&srcFrame);
//    av_frame_free(&dstFrame);
//    return 0;
//}

int main1()
{
    printf("Hello video mark!\n");
    int ret = 0;
    FILE* infile = NULL;
    const char* infileName = "19201080.yuv";
    infile = fopen(infileName, "rb+");
    if(!infile)
    {
        printf("fopen_s() infile failed!\n");
        return -1;
    }

    int in_width = 1920;
    int in_height = 1080;

    FILE* outfile = NULL;
    const char* outfileName = "out_mark.yuv";
    outfile = fopen(outfileName, "wb");
    if(!outfile)
    {
        printf("fopen_s() outfile failed!\n");
        return -1;
    }

    //用于整个过滤流程的一个封装
    AVFilterGraph* filter_grah = avfilter_graph_alloc();
    if(!filter_grah)
    {
        printf("avfilter_graph_alloc() failed!\n");
        return -1;
    }

    char args[512];
    sprintf(args,
            "video_size=%dx%d:pix_fmt=%d:time_base=%d/%d:pixel_aspect=%d/%d",
            in_width, in_height, AV_PIX_FMT_YUV420P,
            1, 25, 1, 1);

    //获取一个用于AVFilterGraph输入的过滤器
    const AVFilter* buffersSrc = avfilter_get_by_name("buffer");
    AVFilterContext* bufferSrc_ctx;
    //将bufferSrc添加到AVFilterGraph中
    //args是用在bufferSrc的参数
    ret = avfilter_graph_create_filter(&bufferSrc_ctx, buffersSrc,
                                       "in", args, NULL, filter_grah);
    if(ret < 0)
    {
        printf("avfilter_graph_create_filter() buffersSrc failed!\n");
        return -1;
    }

    AVBufferSinkParams* bufferSinkParams;
    AVFilterContext* bufferSink_ctx;
    //获取一个用于AVFilterGraph输出的过滤器
    const AVFilter* bufferSink = avfilter_get_by_name("buffersink");
    enum AVPixelFormat pix_fmts[] = {AV_PIX_FMT_YUV420P, AV_PIX_FMT_NONE};
    bufferSinkParams = av_buffersink_params_alloc();
    bufferSinkParams->pixel_fmts = pix_fmts;
    ret = avfilter_graph_create_filter(&bufferSink_ctx, bufferSink,
                                       "out", NULL, bufferSinkParams, filter_grah);
    if(ret < 0)
    {
        printf("avfilter_graph_create_filter() bufferSink failed!\n");
        return -1;
    }


    //split filter(分流)
    const AVFilter* splitFilter = avfilter_get_by_name("split");
    AVFilterContext* splitFilter_ctx;
    //outputs=2 分流2通道
    ret = avfilter_graph_create_filter(&splitFilter_ctx, splitFilter, "split",
                                       "outputs=2", NULL, filter_grah);
    if(ret < 0)
    {
        printf("avfilter_graph_create_filter() splitFilter failed!\n");
        return -1;
    }

    //crop filter(裁剪)
    const AVFilter* cropFilter = avfilter_get_by_name("crop");
    AVFilterContext* cropFilter_ctx;
    ret = avfilter_graph_create_filter(&cropFilter_ctx, cropFilter, "crop",
                                       "out_w=iw:out_h=ih/2:x=0:y=0", NULL, filter_grah);

    if(ret < 0)
    {
        printf("avfilter_graph_create_filter() cropFilter failed!\n");
        return -1;
    }


    //vflip filter(垂直向上的翻转)
    const AVFilter* vflipFilter = avfilter_get_by_name("vflip");
    AVFilterContext* vflipFilter_ctx;
    ret = avfilter_graph_create_filter(&vflipFilter_ctx, vflipFilter, "vflip",
                                       NULL, NULL, filter_grah);
    if(ret < 0)
    {
        printf("avfilter_graph_create_filter() vflipFilter failed!\n");
        return -1;
    }


    //overlay filter(合成)
    const AVFilter* overlayFilter = avfilter_get_by_name("overlay");
    AVFilterContext* overlayFilter_ctx;
    ret = avfilter_graph_create_filter(&overlayFilter_ctx, overlayFilter, "overlay",
                                       "", NULL, filter_grah);

    if(ret < 0)
    {
        printf("avfilter_graph_create_filter() overlayFilter failed!\n");
        return -1;
    }


    //srcFilter -> splitFilter
    //srcpad、dstpad是一个索引，通道的索引
    ret = avfilter_link(bufferSrc_ctx, 0, splitFilter_ctx, 0);
    if(ret != 0)
    {
        printf("avfilter_link() srcFilter -> splitFilter failed!\n");
        return -1;
    }

    //splitFilter[0] -> overlayfilter[0]
    ret = avfilter_link(splitFilter_ctx, 0, overlayFilter_ctx, 0);
    if(ret != 0)
    {
        printf("avfilter_link() splitFilter[0] -> overlayfilter[0] failed!\n");
        return -1;
    }

    //splitFilter[1] -> cropFilter
    ret = avfilter_link(splitFilter_ctx, 1, cropFilter_ctx, 0);
    if(ret != 0)
    {
        printf("avfilter_link() splitFilter[1] -> cropFilter failed!\n");
        return -1;
    }
    \
    //cropFilter -> vflipFilter
    ret = avfilter_link(cropFilter_ctx, 0, vflipFilter_ctx, 0);
    if(ret != 0)
    {
        printf("avfilter_link() cropFilter -> vflipFilter failed!\n");
        return -1;
    }

    //vflipFilter -> overlayfilter[1]
    ret = avfilter_link(vflipFilter_ctx, 0, overlayFilter_ctx, 1);
    if(ret != 0)
    {
        printf("avfilter_link() vflipFilter -> overlayfilter[1] failed!\n");
        return -1;
    }

    //overlayfilter -> bufferSink
    ret = avfilter_link(overlayFilter_ctx, 0, bufferSink_ctx, 0);
    if(ret != 0)
    {
        printf("avfilter_link() overlayfilter -> bufferSink failed!\n");
        return -1;
    }

    //确认所有过滤器的连接
    ret = avfilter_graph_config(filter_grah, NULL);
    if(ret < 0)
    {
        printf("avfilter_graph_config() failed!\n");
        return -1;
    }

    //打印filtergraph的信息
    char* graph_str = avfilter_graph_dump(filter_grah, NULL);
    printf("\n%s\n", graph_str);
    av_free(graph_str);

    //输入帧
    AVFrame* frame_in = av_frame_alloc();
    unsigned char* frame_buffer_in = (unsigned char*)av_malloc(
            av_image_get_buffer_size(AV_PIX_FMT_YUV420P, in_width, in_height, 1));

    //输出帧
    AVFrame* frame_out = av_frame_alloc();

    frame_in->width = in_width;
    frame_in->height = in_height;
    frame_in->format = AV_PIX_FMT_YUV420P;

    uint32_t frame_size = in_width * in_height * 3 / 2;

    while (1)
    {
        //读取yuv数据
        if(fread(frame_buffer_in, 1, frame_size, infile) != frame_size)
        {
            break;
        }

        av_image_fill_arrays(frame_in->data, frame_in->linesize, frame_buffer_in, AV_PIX_FMT_YUV420P, in_width, in_height, 1);


        //添加帧数据到过滤器
        if(av_buffersrc_add_frame(bufferSrc_ctx, frame_in) < 0)
        {
            printf("av_buffersrc_add_frame() failed!\n");
            break;
        }


        //获取输出帧数据
        ret = av_buffersink_get_frame(bufferSink_ctx, frame_out);
        if(ret < 0)
        {
            printf("av_buffersink_get_frame() failed!\n");
            break;
        }


        //输出文件
        if(frame_out->format == AV_PIX_FMT_YUV420P)
        {
            for (int i = 0; i < frame_out->height; i++) {
                fwrite(frame_out->data[0] + frame_out->linesize[0] * i, 1, frame_out->width, outfile);
            }
            for (int i = 0; i < frame_out->height / 2; i++) {
                fwrite(frame_out->data[1] + frame_out->linesize[1] * i, 1, frame_out->width / 2, outfile);
            }
            for (int i = 0; i < frame_out->height / 2; i++) {
                fwrite(frame_out->data[2] + frame_out->linesize[2] * i, 1, frame_out->width / 2, outfile);
            }
        }

        av_frame_unref(frame_out);

    }

    fclose(infile);
    fclose(outfile);

    av_frame_free(&frame_in);
    av_frame_free(&frame_out);
    avfilter_graph_free(&filter_grah);
    printf("end video mark!\n");
    return 0;
}

int main(int argc, char *argv[]){
    av_log_set_level(AV_LOG_DEBUG);
    av_log(nullptr,AV_LOG_INFO,"%s\n","hello world");
    main1();
    return 0;
}

#else
#include <cstdio>
int main(int argc, char *argv[]) {
    printf("The compile option for this test is not turned on\n");
}
#endif