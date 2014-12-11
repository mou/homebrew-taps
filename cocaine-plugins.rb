require "formula"

class CocainePlugins < Formula
  homepage ""
  url "https://github.com/cocaine/cocaine-plugins.git", :using => :git, :tag => "0.11.2.6"
  version "0.11.2.6"
  sha1 ""

  depends_on "cmake" => :build
  depends_on "cocaine"
  depends_on "libev"
  depends_on "msgpack"
  depends_on "boost"
  depends_on "libarchive"


  patch :DATA

  def install
    args = std_cmake_args + %W[
      -DIPVS=OFF
    ]
    mkdir "build" do
        system "cmake", "..", *args
        system "make", "install"
    end
  end

  test do
    system "false"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5865145..c0c6875 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -29,6 +29,7 @@ INCLUDE(cmake/locate_library.cmake)
 LOCATE_LIBRARY(LIBCOCAINE "cocaine/context.hpp" "cocaine-core")
 LOCATE_LIBRARY(LIBEV "ev++.h" "ev" "libev")
 LOCATE_LIBRARY(LIBMSGPACK "msgpack.hpp" "msgpack")
+LOCATE_LIBRARY(LIBJSONCPP "json/json.h" "jsoncpp" "jsoncpp")
 # LOCATE_LIBRARY(LIBZMQ "zmq.h" "zmq")
 
 INCLUDE_DIRECTORIES(BEFORE
@@ -41,14 +42,16 @@ INCLUDE_DIRECTORIES(
     ${LIBCOCAINE_INCLUDE_DIRS}
     ${LIBEV_INCLUDE_DIRS}
     ${LIBMSGPACK_INCLUDE_DIRS}
-    ${LIBZMQ_INCLUDE_DIRS})
+    ${LIBZMQ_INCLUDE_DIRS}
+    ${LIBJSONCPP_INCLUDE_DIRS})
 
 LINK_DIRECTORIES(
     ${Boost_LIBRARY_DIRS}
     ${LIBCOCAINE_LIBRARY_DIRS}
     ${LIBEV_LIBRARY_DIRS}
     ${LIBMSGPACK_LIBRARY_DIRS}
-    ${LIBZMQ_LIBRARY_DIRS})
+    ${LIBZMQ_LIBRARY_DIRS}
+    ${LIBJSONCPP_LIBRARY_DIRS})
 
 SET(PLUGINS
         blastbeat
diff --git a/cache/CMakeLists.txt b/cache/CMakeLists.txt
index c1aed2e..7ee355e 100644
--- a/cache/CMakeLists.txt
+++ b/cache/CMakeLists.txt
@@ -10,6 +10,7 @@ IF(CACHE)
         src/module)
 
     TARGET_LINK_LIBRARIES(cache
+        jsoncpp
         cocaine-core)
 
     SET_TARGET_PROPERTIES(cache PROPERTIES
diff --git a/docker/CMakeLists.txt b/docker/CMakeLists.txt
index 02bd402..8972eb6 100644
--- a/docker/CMakeLists.txt
+++ b/docker/CMakeLists.txt
@@ -15,8 +15,10 @@ IF(DOCKER)
 
     TARGET_LINK_LIBRARIES(docker
         cocaine-core
+        jsoncpp
         curl
-        boost_system)
+        boost_system
+        boost_filesystem)
 
     SET_TARGET_PROPERTIES(docker PROPERTIES
         PREFIX ""
diff --git a/elasticsearch/CMakeLists.txt b/elasticsearch/CMakeLists.txt
index 6a22db2..684ce6d 100644
--- a/elasticsearch/CMakeLists.txt
+++ b/elasticsearch/CMakeLists.txt
@@ -26,7 +26,10 @@ IF(ELASTICSEARCH)
     TARGET_LINK_LIBRARIES(elasticsearch
         swarm
         swarm_urlfetcher
-        cocaine-core)
+        ev
+        cocaine-core
+        jsoncpp
+        boost_system)
 
     SET_TARGET_PROPERTIES(elasticsearch PROPERTIES
         PREFIX ""
diff --git a/logstash/CMakeLists.txt b/logstash/CMakeLists.txt
index ae36669..cc73b97 100644
--- a/logstash/CMakeLists.txt
+++ b/logstash/CMakeLists.txt
@@ -11,6 +11,7 @@ IF(LOGSTASH)
 
     TARGET_LINK_LIBRARIES(logstash
         cocaine-core
+        jsoncpp
         boost_system-mt)
 
     SET_TARGET_PROPERTIES(logstash PROPERTIES
diff --git a/urlfetch/CMakeLists.txt b/urlfetch/CMakeLists.txt
index 612cb71..4aef635 100644
--- a/urlfetch/CMakeLists.txt
+++ b/urlfetch/CMakeLists.txt
@@ -18,6 +18,7 @@ IF(URLFETCH)
 
     TARGET_LINK_LIBRARIES(urlfetch
         cocaine-core
+        jsoncpp
         swarm
         swarm_urlfetcher
    ${Boost_LIBRARIES}

