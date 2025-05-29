# Install script for directory: D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/nori")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/Debug/IlmImf.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/Release/IlmImf.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/MinSizeRel/IlmImf.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/RelWithDebInfo/IlmImf.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/CMakeFiles/IlmImf.dir/install-cxx-module-bmi-Debug.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/CMakeFiles/IlmImf.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/CMakeFiles/IlmImf.dir/install-cxx-module-bmi-MinSizeRel.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/OpenEXR/IlmImf/CMakeFiles/IlmImf.dir/install-cxx-module-bmi-RelWithDebInfo.cmake" OPTIONAL)
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/OpenEXR" TYPE FILE FILES
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfForward.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfExport.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfBoxAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCRgbaFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChannelList.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChannelListAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompressionAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDoubleAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFloatAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFrameBuffer.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfHeader.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfIO.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfIntAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLineOrderAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMatrixAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOpaqueAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOutputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgbaFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStringAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfVecAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfHuf.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfWav.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLut.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfArray.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompression.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLineOrder.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfName.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPixelType.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfVersion.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfXdr.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfConvert.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPreviewImage.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPreviewImageAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChromaticities.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChromaticitiesAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfKeyCode.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfKeyCodeAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTimeCode.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTimeCodeAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRational.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRationalAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFramesPerSecond.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStandardAttributes.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfEnvmap.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfEnvmapAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInt64.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgba.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTileDescription.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTileDescriptionAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledInputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledOutputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledRgbaFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgbaYca.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTestFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfThreading.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfB44Compressor.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStringVectorAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiView.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfAcesFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiPartOutputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfGenericOutputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiPartInputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfGenericInputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPartType.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPartHelper.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOutputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledOutputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledInputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineOutputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineOutputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineInputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineInputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledInputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledInputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledOutputFile.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledOutputPart.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepFrameBuffer.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepCompositing.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompositeDeepScanLine.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfNamespace.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMisc.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepImageState.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepImageStateAttribute.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFloatVectorAttribute.h"
    )
endif()

