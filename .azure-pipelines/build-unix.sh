#!/bin/bash

echo "This is Unix ${CMAKE_BUILD_TYPE}"
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -G "Unix Makefiles" ../native
make
