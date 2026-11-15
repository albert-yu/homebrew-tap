class Pomp < Formula
  desc "Data CLI tool inspired by Boop"
  homepage "https://github.com/albert-yu/pomp"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.5/pomp-aarch64-apple-darwin.tar.xz"
      sha256 "9352af5a213ec33b666dd486354d7fbfc52c8cf6490f320d318f212b09b2d0ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.5/pomp-x86_64-apple-darwin.tar.xz"
      sha256 "f938e3da0a04d2407e55b4661aadbebe4beb7076a7c1d21a99d32bfa1dc24eaf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.5/pomp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "22267816f0875ab182467050512f8828c5d6f0224635d3c29f0537bf169a1e47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.5/pomp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f67f7ba4e148da6aada43c4274d714658e1894f721e4c62ab0860415f08cf5f3"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "pomp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pomp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pomp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pomp"
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
