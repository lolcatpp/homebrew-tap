class Lolcatpp < Formula
  desc "A lolcat reimplementation in C++ -- BLAZINGLY FAST"
  homepage "https://github.com/lolcatpp/lolcatpp"
  url "https://github.com/lolcatpp/lolcatpp/archive/refs/tags/v2.0.1.tar.gz" # source_url_marker
  sha256 "1dd8f93a47bf68fa64651859e2f692928ca8aa7aa5f065db42df6433da5ef5ff" # source_sha_marker
  license "BSD-3-Clause"

  conflicts_with "lolcat", because: "both install a `lolcat` binary"

  resource "binary" do
    url "https://github.com/lolcatpp/lolcatpp/releases/download/v2.0.1/lolcat-macos-arm64" # binary_url_marker
    sha256 "89ca491b4e74de1b20a3951e6f67f6d10bc4e1dfdbef45f13d2c80f29d67149f" # binary_sha_marker
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
