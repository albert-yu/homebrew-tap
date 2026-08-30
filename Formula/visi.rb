class Visi < Formula
  desc "A developer-friendly CLI for reading, evaluating formulas in, and updating Excel (.xlsx) files"
  homepage "https://github.com/albert-yu/visi"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.8/visi-aarch64-apple-darwin.tar.xz"
      sha256 "519e832b239f010967b409f7471a1a980e0110612a211eae42372dcf0eedac5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.8/visi-x86_64-apple-darwin.tar.xz"
      sha256 "d0c9f2781b10ff3900578d2d8b57be12d43bbfc34d178e23da0acaf0eb942ea9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.8/visi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e0b32309779c2fd09d67c269edeb0a67b9da102720933d535cccc2e7d8db73dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/visi/releases/download/v0.2.8/visi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "426051138e2ad705bfba45388d27c6d05339633d1346cfd0fee8dc643569d5c4"
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
