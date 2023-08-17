//
// Created by HFauto on 2022/12/27.
//
#ifdef ENABLE_SPDLOG
#include <iostream>
#include <string>
#include <memory>
#define SPDLOG_ACTIVE_LEVEL SPDLOG_LEVEL_TRACE
#include "spdlog/spdlog.h"
#include "spdlog/async.h"
#include "spdlog/sinks/rotating_file_sink.h"
#include "spdlog/sinks/daily_file_sink.h"
#include "spdlog/sinks/stdout_color_sinks.h"
#include "spdlog/fmt/bin_to_hex.h"

int main_spd(int argc, char *argv[]) {
    std::shared_ptr<spdlog::logger> console = spdlog::stdout_color_mt("console");
//    console->set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%=7n] [%=7l] %v");
//    console->set_pattern("[%Y-%m-%d %H:%M:%S.%e][thread %t][%@,%!][%l] : %v");
    console->set_level(spdlog::level::debug);
    console->flush_on(spdlog::level::debug);

    console->debug("hello");
    console->info("hello");
    console->warn("hello");
    console->error("hello");
    SPDLOG_LOGGER_DEBUG(console, "hello");

    spdlog::drop_all();
    return 0;
}

int main(int argc, char *argv[]){
    return main_spd(argc, argv);
}
#else
#include <cstdio>
int main(int argc, char *argv[]) {
    printf("The compile option for this test is not turned on\n");
}
#endif