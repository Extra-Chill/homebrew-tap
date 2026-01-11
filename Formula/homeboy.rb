class Homeboy < Formula
  desc "CLI tool for development and deployment automation"
  homepage "https://github.com/Extra-Chill/homeboy-cli"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.5/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "abbb0b5db79ede5153f1a05d365e1a5693217d88fd9ad120d7f66f69857713aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.5/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "a105b4903c4afc8bda8f4b39bb99ab24b13d0dcfd372131e4a833277e28efe63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.5/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a70624dd1a862b2d81c3d901bd2b4ad7b2db93da89252ce39bf50e56d0c07139"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy-cli/releases/download/v0.1.5/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf75290cf2a9d091d549e6b18bbe98f7beaaea66dbaae67a9656b248c764359f"
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
