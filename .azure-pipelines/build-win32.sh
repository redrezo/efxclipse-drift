#!/bin/bash

echo "This is Win32 ${CMAKE_BUILD_TYPE}"
mkdir build && cd build
cmake -G "Visual Studio 15 2017 Win64" ../native
msbuild /property:Configuration=${CMAKE_BUILD_TYPE} releng.sln
