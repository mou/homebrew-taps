require "formula"

class Libswarm < Formula
  homepage ""
  url "https://github.com/reverbrain/swarm.git", :using => :git, :tag => "v0.6.5.1"
  sha1 ""

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "uriparser"
  depends_on "libxml2"
  depends_on "libev"
  depends_on "libidn"

  patch :DATA

  def install
    args = std_cmake_args + %W[
      -DPERF=OFF
      -DBUILD_EXAMPLES=OFF
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
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -36,7 +36,6 @@ link_directories(
 )
 
 add_subdirectory(swarm)
-add_subdirectory(thevoid)
 
 option(BUILD_EXAMPLES "Build examples" ON)
 
@@ -48,9 +47,6 @@ if (PERF)
    add_subdirectory(perf)
 endif()
 
-install(DIRECTORY thevoid/rapidjson
-    DESTINATION include/thevoid)
-
 option(WITH_DOXYGEN "Generate documentation by Doxygen" ON)
 
 if(WITH_DOXYGEN)

