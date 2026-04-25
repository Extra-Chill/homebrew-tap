class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.95.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.95.0/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "55ffb14fb0523a33d21de0da03ce0a21d95e5308f5a743675b84192a1bc2fbf6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.95.0/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "b756075071ca3eff7bc7dba87488ce6c9556e91ff2746c0f00c62045b50d05f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.95.0/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b74621ec99960ccf588d84c0abaa181005733c7b79bc62b50cee8937ca0eb5be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.95.0/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "667dbb84021e0c47f0d7f4f04bdc4686f4f80725ec2b2caaf3fd1a024329b183"
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
