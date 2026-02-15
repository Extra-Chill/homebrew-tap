class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.44.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.3/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "5d7c4c16fce7ff81128f345003d2584ca7e51a30a3318cfc04a86f3b21cd2a45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.3/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "613999244ef01e57a6fcb011a0976881a32789e02569b93e8118ee9bf35c84e8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.3/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce913d81be3d7bd3fcb59186611c06d83e46ae99f45ea2a02e20743d20719508"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.3/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ad7ff2fb4b85d4a6ecd107c1ea5c37f9bc91e0e0e97d841321fafa8a7e867a6a"
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
      bin.install "homeboy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "homeboy"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "homeboy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "homeboy"
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
