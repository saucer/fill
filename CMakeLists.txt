cmake_minimum_required(VERSION 3.25)
project(saucer-fill LANGUAGES CXX VERSION 1.0.0)

# --------------------------------------------------------------------------------------------------------
# Library switches
# --------------------------------------------------------------------------------------------------------

option(fill_silent "Whether or not to silently include polyfill headers" OFF)

# --------------------------------------------------------------------------------------------------------
# Library options
# --------------------------------------------------------------------------------------------------------

set(fill_namespace    "stdx"    CACHE STRING "The namespace in which to put the polyfills")
set(fill_replacements "Default" CACHE STRING "The standard library features to replace")

# --------------------------------------------------------------------------------------------------------
# Create library
# --------------------------------------------------------------------------------------------------------

add_library(${PROJECT_NAME} INTERFACE)
add_library(saucer::fill ALIAS ${PROJECT_NAME})

target_compile_features(${PROJECT_NAME} INTERFACE cxx_std_23)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 23 CXX_EXTENSIONS OFF CXX_STANDARD_REQUIRED ON)

# --------------------------------------------------------------------------------------------------------
# Setup macros
# --------------------------------------------------------------------------------------------------------

target_compile_definitions(${PROJECT_NAME} INTERFACE FILL_NAMESPACE=${fill_namespace})

# --------------------------------------------------------------------------------------------------------
# Include directories
# --------------------------------------------------------------------------------------------------------

target_include_directories(${PROJECT_NAME} INTERFACE "include")

# --------------------------------------------------------------------------------------------------------
# Detect default replacements
# --------------------------------------------------------------------------------------------------------

include("cmake/detect.cmake")

if (fill_replacements STREQUAL "Default")
  fill_detect(fill_replacements)
  message(STATUS "[fill] Recommended replacements: ${fill_replacements}")
endif()

# --------------------------------------------------------------------------------------------------------
# Setup Replacements
# --------------------------------------------------------------------------------------------------------

include("cmake/cpm.cmake")

set(fill_headers "")

if ("jthread" IN_LIST fill_replacements)
  message(STATUS "[fill] Using std::jthread replacement")

  CPMFindPackage(
    NAME           jthread
    VERSION        24.00.1
    GIT_REPOSITORY "https://github.com/saucer/jthread"
  )

  target_link_libraries(${PROJECT_NAME} INTERFACE nonstd::jthread)
  list(APPEND fill_headers "include/jthread.hpp")
endif()

if ("functional" IN_LIST fill_replacements)
  message(STATUS "[fill] Using std::move_only_function replacement")

  CPMFindPackage(
    NAME           functional
    VERSION        1.0.2
    GIT_REPOSITORY "https://github.com/zhihaoy/nontype_functional"
  )

  target_link_libraries(${PROJECT_NAME} INTERFACE std23::nontype_functional)
  list(APPEND fill_headers "include/functional.hpp")
endif()

foreach (header IN LISTS fill_headers)
  if (fill_silent)
    target_precompile_headers(${PROJECT_NAME} INTERFACE "${header}")
  endif()
endforeach()
