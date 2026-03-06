class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.60.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.60.0/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "2878a341b40924ec0a36f80b2178ea1a3ea543c9a105ed69d5e78fe5a9038b5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.60.0/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "aaa6d06311a75523c557971177dbe3e4d50d113003601c738fab77e3a31f5704"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.60.0/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67e3c8a5593318797e6ce85aeed7a69bfb2c01186592030f4a2e2fbb8799e1a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.60.0/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "040024c49badcd607111e00c2e3bd5d91cf37c69b5fd691504dd78da33ba9e04"
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
