class Homeboy < Formula
  desc "Headless automation for agentic software engineering workflows"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.221.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.221.0/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "3e716391f5c55ba3a4f97b3a4e87e3196e6b6ea1f412f758cbf1739ea9bdc4ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.221.0/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "26173e92e7ae52908f5574c05f1c34ddb0994884bf87854e19c681855a0b8b73"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.221.0/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cb38226493277982b3c22de09c0f6e23d06932cb9d4d1cd6fd2196e890d2bfd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.221.0/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f22fc049e43813721df44efab962e40a6ddab7d50e26b04dd4dfa7ebd7a46c2"
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
