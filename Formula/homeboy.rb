class Homeboy < Formula
  desc "Headless automation for agentic software engineering workflows"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.281.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.281.15/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "387b6b098a284738c82b5b3f6a81e6ba65aafee2b2f856f7b56485bd1b5f0acd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.281.15/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "b65b75ef23488c4b7d92cf6485a36a3ad059d0eaea1489eeb2252de538b91188"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.281.15/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e98df9148cd9ce9b5eae47eadc5efd60887408d9c6c629c63713702d0f290a44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.281.15/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85a0263ce1f7e6eb4dfcdddecf78ee86c839a0db93fc71a1da7edfc2bf01f295"
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
