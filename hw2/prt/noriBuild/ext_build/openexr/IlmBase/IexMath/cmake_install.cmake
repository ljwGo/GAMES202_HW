# Install script for directory: D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/IlmBase/IexMath

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
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/Debug/IexMath.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/Release/IexMath.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/MinSizeRel/IexMath.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/RelWithDebInfo/IexMath.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/CMakeFiles/IexMath.dir/install-cxx-module-bmi-Debug.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/CMakeFiles/IexMath.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/CMakeFiles/IexMath.dir/install-cxx-module-bmi-MinSizeRel.cmake" OPTIONAL)
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    include("D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/noriBuild/ext_build/openexr/IlmBase/IexMath/CMakeFiles/IexMath.dir/install-cxx-module-bmi-RelWithDebInfo.cmake" OPTIONAL)
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/OpenEXR" TYPE FILE FILES
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/IlmBase/IexMath/IexMathFloatExc.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/IlmBase/IexMath/IexMathFpu.h"
    "D:/Course/02ComputerGraph (计算机图形学)/GAMES202/hw2/prt/ext/openexr/IlmBase/IexMath/IexMathIeeeExc.h"
    )
endif()

