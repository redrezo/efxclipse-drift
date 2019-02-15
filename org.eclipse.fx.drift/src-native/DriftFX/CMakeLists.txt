cmake_minimum_required(VERSION 3.1)
project(DriftFX CXX)

# configuring msvc to include the runtime
if (WIN32)
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
endif (WIN32)

set(DriftFX-Headers
	include/DriftFX/Common.h
	include/DriftFX/DriftFX.h
	include/DriftFX/DriftFXSurface.h
	include/DriftFX/RenderTarget.h
	include/DriftFX/Context.h
	include/DriftFX/Texture.h
	include/DriftFX/GL/GLContext.h
	include/DriftFX/GL/GLTexture.h
)

# list each source file individually
set(DriftFX-Sources
    src/Context.cpp
    src/JNINativeSurface.cpp
    src/NativeSurface.cpp
    src/NativeSurfaceAPI.cpp
    src/NativeSurfaceRegistry.cpp
    src/RenderTarget.cpp
    src/SharedTexture.cpp
    src/Texture.cpp
    
    src/gl/GL.cpp
    src/gl/GLContext.cpp
    src/gl/GLTexture.cpp
    
    src/prism/PrismBridge.cpp
    
    src/DriftFXSurface.cpp
    src/InternalDriftFX.cpp
    
    src/gl/InternalGLContext
)

if (WIN32)
	list(APPEND DriftFX-Sources src/gl/wgl/WGLGLContext)
	
	list(APPEND DriftFX-Sources src/prism/d3d/D3DPrismBridge)
	list(APPEND DriftFX-Sources src/prism/d3d/D3DNativeSurface)
	list(APPEND DriftFX-Sources src/prism/d3d/D3DSharedTexture)
	list(APPEND DriftFX-Sources src/prism/d3d/NativeAPI)
	
	list(APPEND DriftFX-Sources src/win32/D3D9ExContext)
	list(APPEND DriftFX-Sources src/win32/D3D9Texture)
	list(APPEND DriftFX-Sources src/win32/Error)
endif (WIN32)

if (LINUX)
	list(APPEND DriftFX-Sources src/gl/glx/GLXGLContext)
	
	list(APPEND DriftFX-Sources src/prism/es2/ES2PrismBridge)
	list(APPEND DriftFX-Sources src/prism/es2/ES2NativeSurface)
	list(APPEND DriftFX-Sources src/prism/es2/NativeAPI)
	
	list(APPEND DriftFX-Sources src/prism/es2/glx/GLXES2PrismBridge)
	list(APPEND DriftFX-Sources src/prism/es2/glx/GLXSharedTexture)
	list(APPEND DriftFX-Sources src/prism/es2/glx/NativeAPI)
endif (LINUX)


if (APPLE)
	list(APPEND DriftFX-Sources src/gl/cgl/cgl)
	list(APPEND DriftFX-Sources src/gl/cgl/CGLGLContext)
	list(APPEND DriftFX-Sources src/gl/cgl/cgl_context)
	
	list(APPEND DriftFX-Sources src/prism/es2/ES2PrismBridge)
	list(APPEND DriftFX-Sources src/prism/es2/ES2NativeSurface)
	list(APPEND DriftFX-Sources src/prism/es2/NativeAPI)
	
	list(APPEND DriftFX-Sources src/prism/es2/cgl/CGLES2PrismBridge)
	list(APPEND DriftFX-Sources src/prism/es2/cgl/IOSurfaceSharedTexture)
	list(APPEND DriftFX-Sources src/prism/es2/cgl/NativeAPI)
endif (APPLE)


# specify where our headers are
include_directories(include)
include_directories(src)

if (WIN32)
	set(DIRECTX_INCLUDE_DIRS 
		"C:/Program Files (x86)/Microsoft DirectX SDK (June 2010)/Include")
	set(DIRECTX9_LIBRARIES 
		"C:/Program Files (x86)/Microsoft DirectX SDK (June 2010)/Lib/x64/d3d9.lib"
		"C:/Program Files (x86)/Microsoft DirectX SDK (June 2010)/Lib/x64/d3dx9.lib"
		)
#	include_directories(${DIRECTX_INCLUDE_DIRS})
endif (WIN32)

add_library(DriftFX-OBJ OBJECT ${DriftFX-Headers} ${DriftFX-Sources})
target_include_directories(DriftFX-OBJ PUBLIC include)
set_property(TARGET DriftFX-OBJ PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_definitions(DriftFX-OBJ PRIVATE BUILDING_DLL)
target_link_libraries(DriftFX-OBJ PUBLIC Utils-OBJ)
target_link_libraries(DriftFX-OBJ PUBLIC Glew-OBJ)

#target_compile_definitions(DriftFX-OBJ PUBLIC GLEW_STATIC)

if (WIN32)
#target_link_libraries(DriftFX-OBJ PUBLIC opengl32 gdi32)
target_include_directories(DriftFX-OBJ PRIVATE ${DIRECTX_INCLUDE_DIRS})
target_link_libraries(DriftFX-OBJ PUBLIC ${DIRECTX9_LIBRARIES})
endif (WIN32)

