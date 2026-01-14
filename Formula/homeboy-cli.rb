class HomeboyCli < Formula
  desc "CLI tool for development and deployment automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.4/homeboy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d5c9f9ce1d0e0f8d0e89f912a055da3903573192438991f33fb2808d2b8312d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.4/homeboy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9e1e18a4cd3e0ab12f1ffde63b00055a91e561406edf491525fbabbde63e663d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.4/homeboy-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62ba22e2d02cfa601e5041c7a886def51e8fd257c31d3bf0e992da360412e8ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.4/homeboy-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dacf97a09dc1ba9e7c4e4a9c0278d93e6dfcbe6c7005325665c1cb1e5aab39cc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "homeboy" if OS.mac? && Hardware::CPU.arm?
    bin.install "homeboy" if OS.mac? && Hardware::CPU.intel?
    bin.install "homeboy" if OS.linux? && Hardware::CPU.arm?
    bin.install "homeboy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
