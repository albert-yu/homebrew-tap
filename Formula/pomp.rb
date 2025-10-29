class Pomp < Formula
  desc "Data CLI tool inspired by Boop"
  homepage "https://github.com/albert-yu/pomp"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.2/pomp-aarch64-apple-darwin.tar.xz"
      sha256 "09546c258c18e1f6c0e4a68d614d0288dc5af1637080a6b27264dcd5dff5b628"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.2/pomp-x86_64-apple-darwin.tar.xz"
      sha256 "daa5185c8a511e68f6dcd5414f1b7fc8368959cac902059eed5e9ae403c5268b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.2/pomp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7c6b57551c5d1bf1d9669b5ac4078079fa32e9e3f81322bb7085a7971cda399b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.2/pomp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af415da5e35ef51082b42dceddf2348f15ad713ece59e534e1252f1b6b9c9c6d"
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
