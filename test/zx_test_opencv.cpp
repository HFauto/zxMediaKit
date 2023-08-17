//
// Created by HFauto on 2023/1/17.
// Copyright (c) 2023 HFauto. All rights reserved.
//
#ifdef ENABLE_OPENCV
#include <string>
#include <iostream>
#include <ctime>
#include <opencv2/highgui/highgui.hpp>
#include "Util/util.h"
#include "Util/logger.h"

using namespace std;
using namespace cv;
using namespace toolkit;

int main(int argc, char *argv[])
{
    Logger::Instance().add(std::make_shared<ConsoleChannel> ());
    Logger::Instance().add(std::make_shared<FileChannel>());
    Logger::Instance().setWriter(std::make_shared<AsyncLogWriter>());

    string filename = argv[1];
    InfoL << "opencv version:" << CV_VERSION << " capture:"  << filename;
    Mat frame;
    VideoCapture cap;
    cap.open(filename);
    if (!cap.isOpened()) {
        ErrorL << "ERROR! Unable to open camera\n";
        return -1;
    }

    time_t start_time = time(nullptr);
    for (;;) {
        // wait for a new frame from camera and store it into 'frame'
        cap.read(frame);
        // check if we succeeded
        if (frame.empty()) {
            ErrorL << "ERROR! blank frame grabbed\n";
            break;
        }
        // 每隔2s保存图片
        time_t end_time = time(nullptr);
        if ((end_time - start_time) >=2) {

            string name = getTimeStr("%Y-%m-%d %H:%M:%S") + ".jpg";
            InfoL << "2s capture: " << name;
            imwrite(name, frame);
            start_time = time(nullptr);
        }
    }
    cap.release();
    return 0;
}
#endif
