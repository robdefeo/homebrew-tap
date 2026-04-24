class Voxscribe < Formula
  desc "Offline audio transcription using local Whisper models"
  homepage "https://github.com/robdefeo/voxscribe"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/robdefeo/voxscribe/releases/download/v0.2.0/voxscribe-aarch64-apple-darwin.tar.xz"
      sha256 "6e41ebe4f5fbd40bcac7b7c6b51e60d8883d82aca1943696e753ce59bc9de078"
    end
    if Hardware::CPU.intel?
      url "https://github.com/robdefeo/voxscribe/releases/download/v0.2.0/voxscribe-x86_64-apple-darwin.tar.xz"
      sha256 "e14271bc9a126e8f33fac18859ba164eb0634f6370fe93c915b6c2618c4b2e7b"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/robdefeo/voxscribe/releases/download/v0.2.0/voxscribe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fd527788b0dc270e49513d1949af2dc6e23602a7cdc133aa1b0c9dabcbe9bb8e"
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
