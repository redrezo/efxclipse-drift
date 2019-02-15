cmake_minimum_required(VERSION 3.1)
project(glew)

# configuring msvc to include the runtime
if (WIN32)
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
endif (WIN32)

set(Glew-Headers
	include/GL/glew.h
	include/GL/eglew.h
	include/GL/glxew.h
	include/GL/wglew.h
	)

set(Glew-Sources
	src/glew.c
	)

add_library(Glew-OBJ OBJECT ${Glew-Headers} ${Glew-Sources})
target_include_directories(Glew-OBJ PUBLIC "include")
target_compile_definitions(Glew-OBJ PUBLIC GLEW_STATIC) # to get exports
set_property(TARGET Glew-OBJ PROPERTY POSITION_INDEPENDENT_CODE ON)

if (WIN32)
	target_link_libraries(Glew-OBJ PUBLIC opengl32 gdi32)
endif(WIN32)




