class Lolcatpp < Formula
  desc "A lolcat reimplementation in C++ -- BLAZINGLY FAST"
  homepage "https://github.com/lolcatpp/lolcatpp"
  url "https://github.com/lolcatpp/lolcatpp/archive/refs/tags/v2.5.3.tar.gz" # source_url_marker
  sha256 "a8d322c77a67d2843a6a6e48d3119b54d2e19e70b41365b1d26c4e344a98e4af" # source_sha_marker
  license "BSD-3-Clause"

  conflicts_with "lolcat", because: "both install a `lolcat` binary"

  resource "binary" do
    url "https://github.com/lolcatpp/lolcatpp/releases/download/v2.5.3/lolcat-macos-arm64" # binary_url_marker
    sha256 "2d1a063e8af008926e083211995cc7bcf39c6c12ea0200ca0ee1adf8a57b3c73" # binary_sha_marker
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
