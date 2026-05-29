class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.204.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.204.5/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "a9ce24d0ba13712106490127828a219f424119be6fd750572c7c046715f4fe9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.204.5/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "a3a9df7feaa2ffc669fa2c55c067584dbe135161f2c221e4a653d6c57b19678f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.204.5/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "14c888edd310204d23539151bf57ac8a44bdf35b7d8cc205a68fd84da4a0447c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.204.5/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a63474ddc3e495f440308434c4f788cdbcc99627132a38b6c265d3672356fd32"
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
    bin.install "bench-audit-self", "homeboy" if OS.mac? && Hardware::CPU.arm?
    bin.install "bench-audit-self", "homeboy" if OS.mac? && Hardware::CPU.intel?
    bin.install "bench-audit-self", "homeboy" if OS.linux? && Hardware::CPU.arm?
    bin.install "bench-audit-self", "homeboy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
