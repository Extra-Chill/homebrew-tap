class Homeboy < Formula
  desc "CLI for multi-component deployment and development workflow automation"
  homepage "https://github.com/Extra-Chill/homeboy"
  version "0.44.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.4/homeboy-aarch64-apple-darwin.tar.xz"
      sha256 "77721e308e22cb452908fca64f18d18cb20004ffa81f8ea3f7733c0d2bff60ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.4/homeboy-x86_64-apple-darwin.tar.xz"
      sha256 "79b2f1f8ad412c649dffdcf2509e87a868bbec4e82c92fd151576c73e02e6541"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.4/homeboy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f9215adb2f6ee89b6dc4466337731590ed36a54410d1a1f0e4b067b845c18cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Extra-Chill/homeboy/releases/download/v0.44.4/homeboy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68c5a7dbd09d211ea05732b42f4ac29b1a74eac75adcfb5b053047c0f10cc366"
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
