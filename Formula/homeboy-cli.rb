class HomeboyCli < Formula
  desc "CLI tool for development and deployment automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.1/homeboy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5fc6d45eff359ec36431f128d28614963853213c8856d8cd4adaf98016829bf8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.1/homeboy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a6cde8c18ccb0f7faad21ff32fd9a6b1f1db24069c33f6793cb0d2a32c8a696f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.1/homeboy-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86ee78bc9cab41bb2c01ae837795b27387c38a0dec111d415df323d780e29693"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.7.1/homeboy-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5abee527d432972323411f7ad4ddff6b41391c2463a01701648861291fc8780f"
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
