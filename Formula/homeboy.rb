class Homeboy < Formula
  desc "Headless automation for agentic software engineering workflows"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.276.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.276.1/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "9e476f185b59c035aff57c7d25f8141b9d39582c86a458f5a7ec0197b526a8b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.276.1/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "8626bbe8ec2727292e655486c8152329b1d1c6bbc64f556e67cc83c6218b9cd4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.276.1/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9bc3a91b4475d5c45ed828c5ee511eef5c6f7676018141851fb43c37d8aed1be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.276.1/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dada2f32645599734f0d6a654aae4287dcc5a1cb9d1bd62558e7f7c7624755f7"
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
