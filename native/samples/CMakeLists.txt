cmake_minimum_required(VERSION 3.1)
project(samples)

if (UNIX AND NOT APPLE)
	set(LINUX TRUE)
endif ()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")


find_package(JNI REQUIRED)
include_directories(${JNI_INCLUDE_DIRS})

find_package(OpenGL REQUIRED)

include_directories(${DRIFTFX_INCLUDE_DIRS})

list(APPEND SourcesList SimpleColorRenderer)
list(APPEND SourcesList SimpleTriangleRenderer)


# we're building a library
add_library(samples SHARED ${SourcesList})

target_link_libraries(samples driftfx)
set_property(TARGET samples PROPERTY POSITION_INDEPENDENT_CODE ON)
	
	
