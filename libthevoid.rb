require "formula"

class Libthevoid < Formula
  homepage ""
  url "https://github.com/reverbrain/swarm.git", :using => :git, :tag => "v0.6.5.1"
  sha1 ""

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libswarm"
  depends_on "boost"

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
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7ea4b1c..5a04033 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -35,7 +35,6 @@ link_directories(
     ${Boost_LIBRARY_DIRS}
 )

-add_subdirectory(swarm)
 add_subdirectory(thevoid)

 option(BUILD_EXAMPLES "Build examples" ON)
