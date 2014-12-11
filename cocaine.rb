require "formula"

class Cocaine < Formula
  homepage "https://github.com/cocaine/cocaine-core"
  url "https://github.com/cocaine/cocaine-core.git", :using => :git, :tag => "0.11.2.0"
  sha1 ""

  depends_on "cmake" => :build
  depends_on "libtool"
  depends_on "libev"
  depends_on "msgpack"
  depends_on "boost"
  depends_on "libarchive"
  depends_on "jsoncpp"

  patch :DATA
  
  def install

    mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make", "install" # if this fails, try separate make/make install steps
    end
  end

  test do
    system "false"
  end
end

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -49,6 +49,7 @@ LOCATE_LIBRARY(LIBARCHIVE "archive.h" "archive")
 LOCATE_LIBRARY(LIBEV "ev++.h" "ev" "libev")
 LOCATE_LIBRARY(LIBLTDL "ltdl.h" "ltdl")
 LOCATE_LIBRARY(LIBMSGPACK "msgpack.hpp" "msgpack")
+LOCATE_LIBRARY(LIBJSONCPP "json/json.h" "jsoncpp" "jsoncpp")
 
 IF(NOT APPLE)
     LOCATE_LIBRARY(LIBUUID "uuid/uuid.h" "uuid")
@@ -57,6 +58,7 @@ ENDIF()
 
 INCLUDE_DIRECTORIES(
     ${Boost_INCLUDE_DIRS}
+    ${LIBJSONCPP_INCLUDE_DIRS}
     ${LIBCGROUP_INCLUDE_DIRS}
     ${OPENSSL_INCLUDE_DIR}
     ${LIBEV_INCLUDE_DIRS}
@@ -65,26 +67,18 @@ INCLUDE_DIRECTORIES(
     ${LIBLTDL_INCLUDE_DIRS})
 
 INCLUDE_DIRECTORIES(BEFORE
-    ${PROJECT_SOURCE_DIR}/foreign/jsoncpp-0.6.0-rc2/include
     ${PROJECT_SOURCE_DIR}/foreign/backward-cpp
     ${PROJECT_SOURCE_DIR}/include)
 
 LINK_DIRECTORIES(
     ${Boost_LIBRARY_DIRS}
     ${LIBCGROUP_LIBRARY_DIRS}
+    ${LIBJSONCPP_LIBRARY_DIRS}
     ${LIBEV_LIBRARY_DIRS}
     ${LIBMSGPACK_LIBRARY_DIRS}
     ${LIBARCHIVE_LIBRARY_DIRS}
     ${LIBLTDL_LIBRARY_DIRS})
 
-ADD_LIBRARY(json
-    foreign/jsoncpp-0.6.0-rc2/src/lib_json/json_value
-    foreign/jsoncpp-0.6.0-rc2/src/lib_json/json_reader
-    foreign/jsoncpp-0.6.0-rc2/src/lib_json/json_writer)
-
-SET_TARGET_PROPERTIES(json PROPERTIES
-    COMPILE_FLAGS "-fPIC")
-
 ADD_LIBRARY(cocaine-core SHARED
     src/actor
     src/api
@@ -125,7 +119,7 @@ TARGET_LINK_LIBRARIES(cocaine-core
     ${LIBCGROUP_LIBRARY}
     ${LIBCRYPTO_LIBRARY}
     ev
-    json
+    jsoncpp
     ltdl
     msgpack
     ${LIBUUID_LIBRARY})
@@ -153,7 +147,6 @@ INSTALL(
     TARGETS
         cocaine-core
         cocaine-runtime
-        json
     RUNTIME DESTINATION bin COMPONENT runtime
     LIBRARY DESTINATION ${COCAINE_LIBDIR} COMPONENT runtime
     ARCHIVE DESTINATION ${COCAINE_LIBDIR} COMPONENT developement)
@@ -161,6 +154,5 @@ INSTALL(
 INSTALL(
     DIRECTORY
         include/
-        foreign/jsoncpp-0.6.0-rc2/include/
     DESTINATION include
     COMPONENT development)

