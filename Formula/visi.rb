class Visi < Formula
  desc "A developer-friendly CLI for reading, evaluating formulas in, and updating Excel (.xlsx) files"
  homepage "https://github.com/albert-yu/visi"
  version "0.2.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.9/visi-aarch64-apple-darwin.tar.xz"
      sha256 "45a3c7305d2b8ce4192c20ef29ec0eb070a1746baa8cfa14d515b70430377f8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.9/visi-x86_64-apple-darwin.tar.xz"
      sha256 "9fb13471d0ecc96861f3da766e6d6a6a9ee3c8bea17b7543e14f084e9c241c09"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.9/visi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df5089517f29f1a221fdd3066f2e7c242056b5735f4429b93ae54367ab845e67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.9/visi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b66e44bf404df3beba5c0e0343f1900f8b4e52cf5c908c76277a8abd9424ab54"
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
