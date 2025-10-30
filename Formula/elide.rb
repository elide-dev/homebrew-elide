class Elide < Formula
  desc "Fast polyglot runtime for JavaScript, TypeScript, and Python"
  homepage "https://elide.dev"
  version "1.0.0-beta10"
  license "MIT"
  
  on_macos do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/darwin-aarch64/#{version}/elide.txz"
      sha256 "011dfe9bbb6aafba25b7e0d4e3fdb7cd8df5619fe4cc7777e247f252d2d24949"
    end
    on_intel do
      # macOS Intel not available in this version
      raise "Elide #{version} does not support macOS Intel. Only ARM64 (Apple Silicon) is supported."
    end
  end
  
  on_linux do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/linux-aarch64/#{version}/elide.tgz"
      sha256 "e6489c93c53dfe3a12360fb09a7946bf4d56d8046b91e6f5075093030976e00c"
    end
    on_intel do
      url "https://elide.zip/cli/v1/snapshot/linux-amd64/#{version}/elide.tgz"
      sha256 "8d5e563b3910d9475d2fff8fcf8e287a41524ef3c9766bd645f972b6ef10a743"
    end
  end
  
  def install
    libexec.install "elide"
    libexec.install Dir["resources"]
    Dir.glob("#{libexec}/elide").select { |f| File.executable?(f) }.each do |exe|
      bin.install_symlink exe => File.basename(exe)
    end
  end
  
  test do
    # Add a test to verify installation
    assert_match version.to_s, shell_output("#{bin}/elide --version")
  end
end
