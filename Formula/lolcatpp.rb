class Lolcatpp < Formula
  desc "A lolcat reimplementation in C++ -- BLAZINGLY FAST"
  homepage "https://github.com/lolcatpp/lolcatpp"
  url "https://github.com/lolcatpp/lolcatpp/archive/refs/tags/v2.1.0.tar.gz" # source_url_marker
  sha256 "762a7ef585f103186d7b45bf530c9f1677595920c80dba05cf39ab17b13fce64" # source_sha_marker
  license "BSD-3-Clause"

  conflicts_with "lolcat", because: "both install a `lolcat` binary"

  resource "binary" do
    url "https://github.com/lolcatpp/lolcatpp/releases/download/v2.1.0/lolcat-macos-arm64" # binary_url_marker
    sha256 "93601566d4324836b08770006cabb4734b92ec81040af6a44f572157094a02fc" # binary_sha_marker
  end

  depends_on "cmake" => :build
  depends_on "boost" if Hardware::CPU.intel?
  depends_on "fmt" if Hardware::CPU.intel?

  def install
    if Hardware::CPU.arm?
      # ARM64: Install prebuilt binary
      resource("binary").stage do
        bin.install "lolcat-macos-arm64" => "lolcat"
      end
    else
      # Intel: Build from source with polyfills
      args = std_cmake_args + %W[
        -DBUILD_STATIC=OFF
        -DCMAKE_PREFIX_PATH=#{Formula["fmt"].opt_prefix};#{Formula["boost"].opt_prefix}
      ]

      system "cmake", "-S", ".", "-B", "build", *args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    assert_match "lolcat\\+\\+", shell_output("#{bin}/lolcat --version")
  end
end
