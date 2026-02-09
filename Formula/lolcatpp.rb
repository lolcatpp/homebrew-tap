class Lolcatpp < Formula
  desc "A lolcat reimplementation in C++ -- BLAZINGLY FAST"
  homepage "https://github.com/lolcatpp/lolcatpp"
  url "https://github.com/lolcatpp/lolcatpp/archive/refs/tags/v2.5.0.tar.gz" # source_url_marker
  sha256 "4e01f9dfc21f927d220159f7aa89b14b143c8e0024360d6bf54a04c55372e9ce" # source_sha_marker
  license "BSD-3-Clause"

  conflicts_with "lolcat", because: "both install a `lolcat` binary"

  resource "binary" do
    url "https://github.com/lolcatpp/lolcatpp/releases/download/v2.5.0/lolcat-macos-arm64" # binary_url_marker
    sha256 "eb330dcd4437182c0e648f2f6ef164ef890704f04c5638b4cecb00f7c96fd347" # binary_sha_marker
  end

  depends_on "cmake" => :build
  depends_on "boost" if Hardware::CPU.intel?
  depends_on "fmt" if Hardware::CPU.intel?
  depends_on "icu4c" if Hardware::CPU.intel?
  depends_on "zstd" if Hardware::CPU.intel?
  depends_on "xz" if Hardware::CPU.intel?

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
        -DCMAKE_PREFIX_PATH=#{Formula["fmt"].opt_prefix};#{Formula["boost"].opt_prefix};#{Formula["icu4c"].opt_prefix};#{Formula["zstd"].opt_prefix};#{Formula["xz"].opt_prefix}
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
