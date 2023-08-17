//
// Created by HFauto on 2022/12/29.
//
#ifdef ENABLE_CATCH
#define CATCH_CONFIG_MAIN
#include <catch2/catch_all.hpp>
#include "spdlog/spdlog.h"

unsigned int Factorial( unsigned int number ) {
    spdlog::info("i love c++ {}", number);
    return number <= 1 ? number : Factorial(number-1)*number;
}

TEST_CASE( "Factorials are computed", "[factorial]" ) {
    REQUIRE( Factorial(1) == 1 );
    REQUIRE( Factorial(2) == 2 );
    REQUIRE( Factorial(3) == 6 );
    REQUIRE( Factorial(10) == 3628800 );
}

#else
#include <cstdio>
int main(int argc, char *argv[]) {
    printf("The compile option for this test is not turned on\n");
}
#endif