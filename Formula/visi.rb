class Visi < Formula
  desc "A developer-friendly CLI for reading, evaluating formulas in, and updating Excel (.xlsx) files"
  homepage "https://github.com/albert-yu/visi"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.6/visi-aarch64-apple-darwin.tar.xz"
      sha256 "be16dd437df725cc4584d0b7d8970aa2f45182f1fc4cbd7f6ebf48909ad7cfe4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.6/visi-x86_64-apple-darwin.tar.xz"
      sha256 "3f826f39969164f854a38b5ec568ec69fc9e69aed209b3c843317e4810472561"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.6/visi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d078235e4322820ca7b268faba81625276a9942d5a02944afc0cd821f510e522"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.6/visi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7cba2bb6f03075de86b1c1afc7221166e740a4a32e8c2298e4117513a9c20213"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
      bin.install "visi"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "visi"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "visi"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "visi"
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
