//
// Created by HFauto on 2023/1/12.
// Copyright (c) 2023 HFauto. All rights reserved.
//
#ifdef ENABLE_WORKFLOW
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <utility>
#include "workflow/Workflow.h"
#include "workflow/HttpMessage.h"
#include "workflow/HttpUtil.h"
#include "workflow/WFHttpServer.h"
#include "workflow/WFFacilities.h"
#include "spdlog/spdlog.h"

struct tutorial_series_context
{
    std::string url;
    WFHttpTask *proxy_task;
    bool is_keep_alive;
};

void reply_callback(WFHttpTask *proxy_task)
{
    SeriesWork *series = series_of(proxy_task);
    tutorial_series_context *context =
            (tutorial_series_context *)series->get_context();
    auto *proxy_resp = proxy_task->get_resp();
    size_t size = proxy_resp->get_output_body_size();

    if (proxy_task->get_state() == WFT_STATE_SUCCESS)
        spdlog::info("{}: Success. Http Status: {}, BodyLength: {}",
                context->url.c_str(), proxy_resp->get_status_code(), size);
    else /* WFT_STATE_SYS_ERROR*/
        spdlog::error("{}: Reply failed: {}, BodyLength: {}",
                context->url.c_str(), strerror(proxy_task->get_error()), size);
}

void http_callback(WFHttpTask *task)
{
    int state = task->get_state();
    int error = task->get_error();
    auto *resp = task->get_resp();
    SeriesWork *series = series_of(task);
    tutorial_series_context *context = (tutorial_series_context *)series->get_context();
    auto *proxy_resp = context->proxy_task->get_resp();

    if (state == WFT_STATE_SUCCESS)
    {
        const void *body;
        size_t len;

        /* set a callback for getting reply status. */
        context->proxy_task->set_callback(reply_callback);

        /* Copy the remote webserver's response, to proxy response. */
        resp->get_parsed_body(&body, &len);
        resp->append_output_body_nocopy(body, len);
        *proxy_resp = std::move(*resp);
        if (!context->is_keep_alive)
            proxy_resp->set_header_pair("Connection", "close");
    }
    else
    {
        const char *err_string;

        if (state == WFT_STATE_SYS_ERROR)
            err_string = strerror(error);
        else if (state == WFT_STATE_DNS_ERROR)
            err_string = gai_strerror(error);
        else if (state == WFT_STATE_SSL_ERROR)
            err_string = "SSL error";
        else /* if (state == WFT_STATE_TASK_ERROR) */
            err_string = "URL error (Cannot be a HTTPS proxy)";

        spdlog::error("{}: Fetch failed. state = {}, error = {}: {}",
                context->url.c_str(), state, error, err_string);

        /* As a tutorial, make it simple. And ignore reply status. */
        proxy_resp->set_status_code("404");
        proxy_resp->append_output_body_nocopy(
                "<html>404 Not Found.</html>", 27);
    }
}

void process(WFHttpTask *proxy_task)
{
    auto *req = proxy_task->get_req();
    SeriesWork *series = series_of(proxy_task);
    WFHttpTask *http_task; /* for requesting remote webserver. */

    tutorial_series_context *context = new tutorial_series_context;
    context->url = req->get_request_uri();
    context->proxy_task = proxy_task;

    spdlog::info("{}", context->url);

    series->set_context(context);
    series->set_callback([](const SeriesWork *series) {
        delete (tutorial_series_context *)series->get_context();
    });

    context->is_keep_alive = req->is_keep_alive();
    http_task = WFTaskFactory::create_http_task(req->get_request_uri(), 0, 0,
                                                http_callback);

    const void *body;
    size_t len;

    /* Copy user's request to the new task's reuqest using std::move() */
    spdlog::info("{}", http_task->get_req()->get_request_uri());
    spdlog::info("{}", http_task->get_req()->get_method());
    spdlog::info("{}", http_task->user_data);
    req->set_request_uri(http_task->get_req()->get_request_uri());
    req->get_parsed_body(&body, &len);
    req->append_output_body_nocopy(body, len);
    *http_task->get_req() = std::move(*req);

    /* also, limit the remote webserver response size. */
    http_task->get_resp()->set_size_limit(200 * 1024 * 1024);

    *series << http_task;
}

static WFFacilities::WaitGroup wait_group(1);

void sig_handler(int signo)
{
    wait_group.done();
}

int main(int argc, char *argv[])
{
    unsigned short port;

    if (argc != 2)
    {
        spdlog::info("usage: {} <port>", argv[0]);
        exit(1);
    }
    spdlog::info("proxy listen to: {}", argv[1]);

    port = atoi(argv[1]);
    signal(SIGINT, sig_handler);

    struct WFServerParams params = HTTP_SERVER_PARAMS_DEFAULT;
    /* for safety, limit request size to 8MB. */
    params.request_size_limit = 8 * 1024 * 1024;

    WFHttpServer server(&params, process);

    if (server.start(port) == 0)
    {
        wait_group.wait();
        server.stop();
    }
    else
    {
        spdlog::info("Cannot start server");
        exit(1);
    }

    return 0;
}

#else
#include <cstdio>
int main(int argc, char *argv[]) {
    printf("The compile option for this test is not turned on\n");
}
#endif