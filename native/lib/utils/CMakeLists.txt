cmake_minimum_required(VERSION 3.1)
project(utils CXX)


set(TARGET              utils)
set(PUBLIC_HDR_DIR      include)


# public headers are always in include/${TARGET}/
file(GLOB_RECURSE Utils-Headers ${PUBLIC_HDR_DIR}/${TARGET}/*.h)

# list each source file individually
set(Utils-Sources
    src/JNIHelper.cpp
    src/Logger.cpp
)

# specify where our headers are
include_directories(${PUBLIC_HDR_DIR})

# add object target
add_library(Utils-OBJ OBJECT ${Utils-Headers} ${Utils-Sources})
target_include_directories(Utils-OBJ PUBLIC include)
set_property(TARGET Utils-OBJ PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_definitions(Utils-OBJ PRIVATE BUILDING_DLL)


