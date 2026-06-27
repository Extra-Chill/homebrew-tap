class Homeboy < Formula
  desc "Headless automation for agentic software engineering workflows"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.266.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.266.0/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "890a021bd25fc5cc3857c15ed1e887909921469f957a2932bf41aaebd40d1bfc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.266.0/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "14c8e625e0a0fd6c6db5947ca03c5aff54fc6f8f1e2946f62c48cb01171a5009"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.266.0/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20da71ee77912f19a12b65655c8622ca6e56aa6cbc27850f16744999802eaab5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.266.0/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73663af1f74eee3d52ce4c8a0b54597a3181b287609fb24fd69123c968c89c56"
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
      bin.install "bench-audit-self", "homeboy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bench-audit-self", "homeboy"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bench-audit-self", "homeboy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bench-audit-self", "homeboy"
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
