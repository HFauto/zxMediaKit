//
// Created by HFauto on 2022/12/29.
//
#ifdef ENABLE_WORKFLOW
#include "spdlog/spdlog.h"
#include "workflow/WFHttpServer.h"

int main(int argc, char *argv[]){
    spdlog::info("Hello World!");
    WFHttpServer server([](WFHttpTask *task) {
//        task->get_resp()->append_output_body("<html>Hello World!</html>");
        task->get_resp()->append_output_body("./");
        spdlog::info("Hello World!");
    });
    int port = 8890;
    if (server.start(8890) == 0) {
        spdlog::info("start http server on port {}", port);
        getchar(); // press "Enter" to end.
        server.stop();
    }
}
#else
#include <cstdio>
int main(int argc, char *argv[]) {
    printf("The compile option for this test is not turned on\n");
}
#endif