class Pomp < Formula
  desc "Data CLI tool inspired by Boop"
  homepage "https://github.com/albert-yu/pomp"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.3/pomp-aarch64-apple-darwin.tar.xz"
      sha256 "64d7dd4c5cf3fb44d6e87426889ac6a33d2c8f3451abb955b69b4f2bcb24deee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.3/pomp-x86_64-apple-darwin.tar.xz"
      sha256 "6581d22a393f1fcba8921b810b8a797b5131648d45ddb2c0008b2df2687525b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.3/pomp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efc089181bb94d191e7167f48dc95f353542cb563e00a241636990bee670739a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albert-yu/pomp/releases/download/v0.1.3/pomp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11169c0ce13f8261acb0f1eefcfd6f09b8e76f0f30694b9640b34893919dbc27"
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
