class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.197.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.4/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "9451ce29e0dc13bc07e32fd05f6863d60fa1198e1ec80b7a47371f4dee76956d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.4/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "21c27b75bdaa2dda4d275ccb3825db28ff94e19b76019dae3b5c45af21add280"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.4/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f283a96e8a2cf9f8404db4f6cde902130ff0d7b25f745d7c25179507adff285"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.197.4/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fff3b43a37bed0926b62c8a6ca0df08942f5f00f3468e211a07853caf74e413e"
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
