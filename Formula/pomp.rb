class Pomp < Formula
  desc "Data CLI tool inspired by Boop"
  homepage "https://github.com/albert-yu/pomp"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.4/pomp-aarch64-apple-darwin.tar.xz"
      sha256 "f7c0bf6cb20a028022d14b8642768df78d128f04a3526486ee19321a6b8e61bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.4/pomp-x86_64-apple-darwin.tar.xz"
      sha256 "cd190f372d8453ceebad80bd4559cab4fda7b6ffc70f1e4a9ff5f61a8d0d8512"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.4/pomp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "76c0a92e2c0cfd8b2014a232270fb835ce43512b9ffe0ca9891ee96702d560ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.4/pomp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cf3dd0321cd13c9003c6154f4d97d44b20c3d88bfaa2662b299c30576379aaf7"
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
