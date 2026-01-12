class Homeboy < Formula
  desc "CLI tool for development and deployment automation"
  homepage "https://github.com/Extra-Chill/homeboy-cli"
  version "0.2.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.2.18/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "db12f806efa9bb3b7991078e169f28a23ddcef6337cce2406e65a4c3326342ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.2.18/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "2ab7561c34a13d1a705e1bf1170312e47ec3b370e7a879586a478216a04fa801"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.2.18/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8eb825f184c5ffff986adfaac8fd74b6a1f759450a6a4b75ba6e39db238f1512"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.2.18/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c17b1c651e76aeccbe9b4ad6c2578402d45ecb5b01875aa9d110df4b524a1d67"
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
