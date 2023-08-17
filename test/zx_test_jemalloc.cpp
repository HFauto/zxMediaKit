//
// Created by HFauto on 2023/1/3.
//
#ifdef ENABLE_JEMALLOC
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <jemalloc/jemalloc.h>

void do_something(size_t i) {
    // Leak some memory.
    malloc(i * 100);
}

//int main1(int argc, char **argv) {
//    for (size_t i = 0; i < 1000; i++) {
//        do_something(i);
//    }
//    // Dump allocator statistics to stderr.
//    malloc_stats_print(NULL, NULL, NULL);
//    return 0;
//}

int main2(int argc, char **argv)
{
    size_t i, sz;

    for (i = 0; i < 100; i++) {
        do_something(i);

        // Update the statistics cached by mallctl.
        uint64_t epoch = 1;
        sz = sizeof(epoch);
        mallctl("epoch", &epoch, &sz, &epoch, sz);

        // Get basic allocation statistics.  Take care to check for
        // errors, since --enable-stats must have been specified at
        // build time for these statistics to be available.
        size_t sz, allocated, active, metadata, resident, mapped;
        sz = sizeof(size_t);
        if (mallctl("stats.allocated", &allocated, &sz, NULL, 0) == 0
            && mallctl("stats.active", &active, &sz, NULL, 0) == 0
            && mallctl("stats.metadata", &metadata, &sz, NULL, 0) == 0
            && mallctl("stats.resident", &resident, &sz, NULL, 0) == 0
            && mallctl("stats.mapped", &mapped, &sz, NULL, 0) == 0) {
            fprintf(stderr,
                    "Current allocated/active/metadata/resident/mapped: %zu/%zu/%zu/%zu/%zu\n",
                    allocated, active, metadata, resident, mapped);
        }
    }
    return (0);
}

#define MSECOND 1000000
int main3(int argc, char **argv)
{
    int i = 0;
    char pad = 0;
    void *ptr = NULL;
    size_t size = 128;
    float timeuse = 0;
    struct timeval tpstart;
    struct timeval tpend;
    int loops = 100000000;

    srand((int)time(0));

    gettimeofday(&tpstart, NULL);
    for (i = 0; i < loops; i++) {
        size = rand() & 0x0000000000000fff;
        ptr = malloc(size);
        pad = rand() & 0xff;
        memset(ptr, pad, size);
        free(ptr);
    }
    gettimeofday(&tpend, NULL);

    timeuse=MSECOND*(tpend.tv_sec-tpstart.tv_sec)+tpend.tv_usec-tpstart.tv_usec;
    timeuse/=MSECOND;
    printf("Used Time [%f] with [%d] loops\n", timeuse, loops);

    return 0;
}

int main(int argc, char **argv) {
    main1(argc,argv);
    main2(argc,argv);
    main3(argc,argv);
    return 0;
}
#else
#include <cstdio>
int main(int argc, char *argv[]) {
    printf("The compile option for this test is not turned on\n");
}
#endif