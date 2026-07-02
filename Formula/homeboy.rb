class Homeboy < Formula
  desc "Headless automation for agentic software engineering workflows"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.279.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.279.0/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "92331992083bdc94a53c463baa7500caec8574e83bd627ff2516b2994a3c69bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.279.0/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "3cfa093f3cad459cdbde7f1d85b1fd8b3dc6a8f345c7522888b728e2127dbb01"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.279.0/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c4b883a96fb837fcc3e266260fb49dbe96ad0c9edcae89449ef2140cae09aea7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.279.0/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "266a8a8f8efd18e7b7d201162408592b088077f2f58126f365d7696335c677fc"
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
