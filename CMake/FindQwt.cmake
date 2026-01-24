##
## This file is part of the SmuView project.
##
## Copyright (C) 2025 Frank Stettner <frank-stettner@gmx.net>
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

include(FindPackageHandleStandardArgs)

set(QWT_PATH_SUFFIXES qwt qwt6 qwt-qt5 qwt-qt6 qwt6-qt5 qwt6-qt5 qt5/qwt qt6/qwt qt5/qwt6 qt6/qwt6 lib/qwt.framework/Headers)
set(QWT_LIBRARY_NAMES qwt qwt6 qwt-qt5 qwt-qt6 qwt6-qt5 qwt6-qt6)

# Try to find Qwt in the user specivied CMAKE_PREFIX_PATH path
find_path(QWT_INCLUDE_DIR NAMES qwt.h qwt_global.h
    NO_DEFAULT_PATH
    PATHS ${CMAKE_PREFIX_PATH}
    PATH_SUFFIXES include ${QWT_PATH_SUFFIXES}
)
find_library(QWT_LIBRARY NAMES ${QWT_LIBRARY_NAMES}
    NO_DEFAULT_PATH
    PATHS ${CMAKE_PREFIX_PATH}
    PATH_SUFFIXES lib
)

if(NOT QWT_INCLUDE_DIR OR NOT QWT_LIBRARY)
  find_path(QWT_INCLUDE_DIR NAMES qwt.h qwt_global.h
      PATHS /usr/local/opt/qwt/include/qwt /usr/local/opt/qwt
      PATH_SUFFIXES ${QWT_PATH_SUFFIXES}
      NO_DEFAULT_PATH)
  find_library(QWT_LIBRARY NAMES ${QWT_LIBRARY_NAMES}
      PATHS /usr/local/opt/qwt/lib
      NO_DEFAULT_PATH)
endif()

# Now search in the default paths
if(NOT QWT_INCLUDE_DIR OR NOT QWT_LIBRARY)
  find_path(QWT_INCLUDE_DIR NAMES qwt.h qwt_global.h
    PATH_SUFFIXES ${QWT_PATH_SUFFIXES})
  find_library(QWT_LIBRARY
    NAMES ${QWT_LIBRARY_NAMES})
endif()

# Get version
if(QWT_INCLUDE_DIR)
  if(EXISTS "${QWT_INCLUDE_DIR}/qwt_version_info.h")
    file(READ "${QWT_INCLUDE_DIR}/qwt_version_info.h" qwt_header)
  else()
    file(READ "${QWT_INCLUDE_DIR}/qwt_global.h" qwt_header)
  endif()
  string(REGEX REPLACE ".*QWT_VERSION_STR +\"([^\"]+)\".*" "\\1" QWT_VERSION_STR "${qwt_header}")
endif()

find_package_handle_standard_args(Qwt
  REQUIRED_VARS QWT_LIBRARY QWT_INCLUDE_DIR
  VERSION_VAR QWT_VERSION_STR)

if(QWT_FOUND)
  mark_as_advanced(QWT_LIBRARY)
  mark_as_advanced(QWT_INCLUDE_DIR)
endif()
