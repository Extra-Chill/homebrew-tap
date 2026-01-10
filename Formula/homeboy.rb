class Homeboy < Formula
  desc "CLI tool for development and deployment automation"
  homepage "https://github.com/Extra-Chill/homeboy-cli"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.4/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "db31fc307467bca912022a469f3bb52a0a948d4c15e57bbbd5f26a033b1ebcb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.4/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "c550de7190978d7b81f81299f526b8140c0c434984682ae5a88987f57bcfff47"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.4/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ca11da39f3c0d76f98086518f124a04cf591ada8607867b75e632068a8bdc8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.4/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bd6c261f82ad038a1e92501986e85e1e2ef0337683266783e439805214416398"
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
