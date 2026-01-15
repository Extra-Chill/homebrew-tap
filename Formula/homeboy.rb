class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.19.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.19.1/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "b294381e0fb56aa770a3ef66092073ae1b303745a174cc5f8ea68276a893f350"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.19.1/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "d10dc96221e1289b55d1abb54f2d99bb0dd58d8aa274ca0d3a33db1b028cc623"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.19.1/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a688064d407d6bccad468c0117034c22777fc2abb5900e226412d0b50ee590e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.19.1/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "37b2c7ca83903953daeefe41dde28b311c31a3eaf94dd020a485ea15683ab50d"
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
