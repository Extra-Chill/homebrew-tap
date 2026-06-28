class Homeboy < Formula
  desc "Headless automation for agentic software engineering workflows"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.269.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.269.3/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "a38cf738eeb8abc211d935e26557b6f22f69dc3b9f4715c97424c507ec7a737c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.269.3/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "2f83f6f5b7483d426587b080b700219001025244d23930b1da69fb988308fe97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.269.3/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "db3f15ffe2abef1fe6994902c978fb3e1527ec76f2d119e0aa478ccb4cccfe46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.269.3/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bbae3c433d957af51bc940f3d3e934ea16fd021b60fb036bef4fd6fe7c1cce34"
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
