class Visi < Formula
  desc "A developer-friendly CLI for reading, evaluating formulas in, and updating Excel (.xlsx) files"
  homepage "https://github.com/albert-yu/visi"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.5/visi-aarch64-apple-darwin.tar.xz"
      sha256 "0529dddcb410fe0505f7f360c97ddd45929d027a8a3fbcde4b92059058ee4028"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.5/visi-x86_64-apple-darwin.tar.xz"
      sha256 "f0dcd101ad6f956eebfc4e9656d2d44726867592038af5d5051e7a022c835475"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.5/visi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "22fbe21d2aa10d52a472e19e9b229633ee2b727d7f6f86305badff93dcce9db5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.5/visi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ad4a5ce51a000d65b78b6e675ba41fe0af298a30a4d9d75773dd2892a753bce"
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
