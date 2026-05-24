class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.197.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.6/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "d207c51bd7c81f22fd570c8f28894b1f0e2651fa616fb8c3065fbd196662a1bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.6/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "b62c16fcd605ced40279594fb6382546a8bada6f284ac01af84e75b8221fc4d5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.6/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e777db39dbe8e42f973907531801c65f576f9783d5d2b9b43200108ec013f5af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.6/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8557838a103843d89d3b3e7825aa32799d95f490df601fe66a3e967202d0e3ab"
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
