require "formula"

class CocaineFramework < Formula
  homepage ""
  url "https://github.com/cocaine/cocaine-framework-native.git", :using => :git, :branch => "v0.11"
  version "0.11.1.2"
  sha1 ""

  depends_on "cmake" => :build
  depends_on "cocaine"
  depends_on "boost"
  depends_on "libev"
  depends_on "msgpack"

  def install
    mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test cocaine-framework`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
