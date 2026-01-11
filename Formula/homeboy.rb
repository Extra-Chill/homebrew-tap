class Homeboy < Formula
  desc "CLI tool for development and deployment automation"
  homepage "https://github.com/Extra-Chill/homeboy-cli"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/0.1.11/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "830209a80e64c594458b5165e9598d6a01e3985e9bcffa711ab0bc5416f2a0d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/0.1.11/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "1c51747ae13336c9ca21448b9696122ce5e6402590287983d7f4d02cc1910d0a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/0.1.11/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0093dd121706c683e53958ad883f633187a875c16f7075cc00aa23194a1627e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/0.1.11/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "09ed793722dbe3bcd7837f242f280abbf8eb9e270fe9e9fb8e9c50721f53e9e2"
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
