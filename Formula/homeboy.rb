class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.44.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.1/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "926e44f2a55947dfddc1f8c374fbb16ca42170f7e8b9434c7dedf3c3f14199c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.1/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "29f8e9081104c98f0acb1edb02ad3aa07a2ceac535dfbb636ba781b1d7fac3d4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.1/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b79468c62a90f9405ef9355e043be7547c24ef570d3487ba470fdcd33bb384a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.1/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f47cdd5de90f688c8410ec6ed894f7034b123d94bf271ac74c39be6311ab780"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "homeboy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "homeboy"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "homeboy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "homeboy"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
