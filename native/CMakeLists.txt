cmake_minimum_required(VERSION 3.12)

project(releng)

if (UNIX AND NOT APPLE)
	set(LINUX TRUE)
endif ()

if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
	set(MSVC TRUE)
endif ()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

if (MSVC)
	# in windows we want to always include the msvc runtime in the dll
	set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
	set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MT")
	set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /VERBOSE:LIB /NODEFAULTLIB:libc.lib /NODEFAULTLIB:libcmtd.lib /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:libcd.lib /NODEFAULTLIB:msvcrtd.lib")
endif (MSVC)

#if (WIN32)
#set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-rpath,$$ORIGIN -Wl,--export-all-symbols -static-libgcc -static-libstdc++ -static -lpthread")
#endif (WIN32)

#if (APPLE)
#set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-rpath,$$ORIGIN  -static-libgcc -static-libstdc++ -static -lpthread")
#endif (APPLE)

#enable_testing()

if (APPLE)
  # since apple deprecated OpenGL we do not want to see this during the build
  add_compile_definitions(GL_SILENCE_DEPRECATION)
endif (APPLE)


# JNI
# TODO improve this (look for jdk8 JNI)
find_package(JNI REQUIRED)

message("JNI: " ${JNI_INCLUDE_DIRS})
message("JNI: " ${JNI_LIBRARIES})

# OpenGL
find_package(OpenGL REQUIRED)

if (WIN32)
	list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

	find_package(WindowsSDK REQUIRED)
	get_windowssdk_include_dirs(${WINDOWSSDK_LATEST_DIR} WINSDK_INCLUDE_DIRS)
	get_windowssdk_library_dirs(${WINDOWSSDK_LATEST_DIR} WINSDK_LIBRARY_DIRS)

	message("WinSDK include: ${WINSDK_INCLUDE_DIRS}")
	message("WinSDK lib: ${WINSDK_LIBRARY_DIRS}")
	find_path(DIRECTX_INCLUDE_DIRS
		NAMES d3d9.h
		HINTS ${WINSDK_INCLUDE_DIRS})

	message ("DirectX Include: ${DIRECTX_INCLUDE_DIRS}")

	find_library(DIRECTX9_LIBRARIES
		NAMES d3d9
		PATHS ${WINSDK_LIBRARY_DIRS})

	message ("DirectX9 Lib: ${DIRECTX9_LIBRARIES}")
endif (WIN32)

include_directories(${JNI_INCLUDE_DIRS})

if (APPLE)
# Add macos framework symlinks for CDT
include_directories( "../../MacOSFrameworks/" )
include_directories( "../../JNIHeader/" )
endif (APPLE)

add_subdirectory(lib/glew)
add_subdirectory(lib/utils)

add_subdirectory(DriftFX)


list(APPEND LinkLibraries ${OPENGL_LIBRARIES})

if (WIN32)
list(APPEND LinkLibraries ${DIRECTX9_LIBRARIES})
endif (WIN32)


if (APPLE)
list(APPEND LinkLibraries "-framework OpenGL")
list(APPEND LinkLibraries "-framework Cocoa")
list(APPEND LinkLibraries "-framework IOSurface")
list(APPEND LinkLibraries "-framework CoreFoundation")
endif (APPLE)

# configuring msvc to include the runtime
if (WIN32)
#set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MT")

endif (WIN32)
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

include_directories(${DRIECTX_INCLUDE_DIRS})

#add_library(driftfx SHARED 
#	$<TARGET_OBJECTS:DriftFX-OBJ> 
#	$<TARGET_OBJECTS:Utils-OBJ> 
#	$<TARGET_OBJECTS:Glew-OBJ>)
#target_compile_definitions(driftfx PRIVATE GLEW_BUILD) # TODO verify if we need this
#target_compile_definitions(driftfx PUBLIC GLEW_STATIC)

#target_link_libraries(driftfx PRIVATE ${OPENGL_LIBRARIES} ${DIRECTX9_LIBRARIES})


else ()

#add_library(driftfx SHARED 
#	$<TARGET_OBJECTS:DriftFX-OBJ> 
#	$<TARGET_OBJECTS:Utils-OBJ> 
#	$<TARGET_OBJECTS:Glew-OBJ>)

if (APPLE)
set(LIB_NAME libdriftfx.dylib)
#target_link_options(driftfx PRIVATE "-Wl,-all_load")
#target_link_libraries(driftfx
#			${LinkLibraries}
#)
endif (APPLE)

if (LINUX)
	set(LIB_NAME libdriftfx.so)
	
#	target_link_libraries(driftfx
#		${LinkLibraries}
#)

endif (LINUX)


endif ()

add_subdirectory(samples)

#add_custom_command(TARGET driftfx POST_BUILD
#	COMMAND ${CMAKE_COMMAND} -E copy_if_different
#		"$<TARGET_FILE:driftfx>"
#		"${PROJECT_SOURCE_DIR}/../native/${LIB_NAME}")
#		

		
