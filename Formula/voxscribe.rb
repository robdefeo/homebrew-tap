class Voxscribe < Formula
  desc "Offline audio transcription using local Whisper models"
  homepage "https://github.com/robdefeo/voxscribe"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/robdefeo/voxscribe/releases/download/v0.1.0/voxscribe-aarch64-apple-darwin.tar.xz"
      sha256 "da8fcfda90d01e1e7096a6a63f9036a32ff58113a8a4ccd8a352d8861e6a2fc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/robdefeo/voxscribe/releases/download/v0.1.0/voxscribe-x86_64-apple-darwin.tar.xz"
      sha256 "035039126fe11c92ced5f7c2454c44f72bcb78842cb4cbfa14e67e3795a71f2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/robdefeo/voxscribe/releases/download/v0.1.0/voxscribe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a234ab5c40c84e1d51cb6c018213b62873313bdce3eeae371e66f8f49d2125e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "voxscribe"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "voxscribe"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "voxscribe"
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
