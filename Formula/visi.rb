class Visi < Formula
  desc "A developer-friendly CLI for reading, evaluating formulas in, and updating Excel (.xlsx) files"
  homepage "https://github.com/albert-yu/visi"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.10/visi-aarch64-apple-darwin.tar.xz"
      sha256 "2a77102748d4bad788d35809dc61c8adb55916020b3a2a282ac724a31ed89ec8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.10/visi-x86_64-apple-darwin.tar.xz"
      sha256 "4f7d93949b072627ff5e81b92d27f27b92bea508d80f989d1f4b062f0ae34007"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.10/visi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7193ed54e42f32769e06cc4eaef34eb1cdb2041df05644a5b9d44e19acda429f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.10/visi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee963fd76476df6866674f7d8bd775ed9aa162241b6e8340cd2f89117d9017e2"
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
