class Elide < Formula
  desc "Fast polyglot runtime for JavaScript, TypeScript, and Python"
  homepage "https://elide.dev"
  version "1.0.0-beta8"
  license "MIT"
  
  on_macos do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/darwin-aarch64/#{version}/elide.txz"
      sha256 "061f5035690e4d1859cbf49cb1559958a2d0b0b7f17f2a257583ce56d5c123ba"
    end
    on_intel do
      # macOS Intel not available in this version
      raise "Elide #{version} does not support macOS Intel. Only ARM64 (Apple Silicon) is supported."
    end
  end
  
  on_linux do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/linux-aarch64/#{version}/elide.tgz"
      sha256 "f5bdc8845726cb32564cd8ea97c286e8c5ef243662bb52480ff553c29c7231d7"
    end
    on_intel do
      url "https://elide.zip/cli/v1/snapshot/linux-amd64/#{version}/elide.tgz"
      sha256 "a5430b7e398c12b66fc6a13a1ac3fd1a7622db48b0a312ccce6232aafa40d23d"
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
