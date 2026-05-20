class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.194.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.194.0/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "d6f8580797c53f61e24c62f47342f1aa41920e6b9d53002834743c5c94f148b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.194.0/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "ae143e5bb8779d897ca50e32c4c4fff32f675608d1ba827e5e9191610b066c4b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.194.0/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "db9097eb20564b45323e887223af2057db1e89d077e63be995ffc9df6f5c6954"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.194.0/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "be7c6724edd8511c73ad8d8970f550e49dd8ba6506c08f378e3de76cf81608c5"
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
