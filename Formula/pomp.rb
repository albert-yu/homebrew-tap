class Pomp < Formula
  desc "Data CLI tool inspired by Boop"
  homepage "https://github.com/albert-yu/pomp"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.1/pomp-aarch64-apple-darwin.tar.xz"
      sha256 "b8a83fcf9d8dbf100afe5f694088f3197870ba0e13ef9096c0e3a3fa33fa92e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.1/pomp-x86_64-apple-darwin.tar.xz"
      sha256 "f4d089098d9ba04a7d25129e54aac1b9f0799b6e3d6887979c347a2ddacb8210"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.1/pomp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8964a419e5f5ff3e0eedad5de9b4dcb2b37f0ce78a1d2346219e47151d58274"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.1/pomp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7cb0d970899f20ebbea0a75a7a9d3b95bfc17c3dce81f6ca2974690ccd0b5fcb"
    end
  end

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
    bin.install "pomp" if OS.mac? && Hardware::CPU.arm?
    bin.install "pomp" if OS.mac? && Hardware::CPU.intel?
    bin.install "pomp" if OS.linux? && Hardware::CPU.arm?
    bin.install "pomp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
