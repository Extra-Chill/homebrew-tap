class Homeboy < Formula
  desc "CLI tool for development and deployment automation"
  homepage "https://github.com/Extra-Chill/homeboy-cli"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.4.0/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "31f0444a43a7178720ab7ec8b81d5ac876fb3a28e336951570cc9d9c2b52c4af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.4.0/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "d7dafc7832d591b4acc2f9953bd2b9373b925fe8509fa3ae0ee88aa7e2df02d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.4.0/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a50571ff18a481ec5961ca0c3daddca43ac4500f51774e7de422042e0e03af8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.4.0/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2cdbfedf042a1a0e85eed491231ba53127665fc9dd0804739673406d53424ce"
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
