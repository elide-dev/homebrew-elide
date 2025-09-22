class Elide < Formula
  desc "Fast polyglot runtime for JavaScript, TypeScript, and Python"
  homepage "https://elide.dev"
  version "1.0.0-beta9"
  license "MIT"
  
  on_macos do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/darwin-aarch64/#{version}/elide.txz"
      sha256 "47d4ca73f211cc5e70e0a8b857a02c5bb4192633f96927509a8b4901ffee997c"
    end
    on_intel do
      # macOS Intel not available in this version
      raise "Elide #{version} does not support macOS Intel. Only ARM64 (Apple Silicon) is supported."
    end
  end
  
  on_linux do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/linux-aarch64/#{version}/elide.tgz"
      sha256 "34c3aed8a9d3ac243ea62100c8ee1e17ce2d6e218f578626916feb7feb9b84ef"
    end
    on_intel do
      url "https://elide.zip/cli/v1/snapshot/linux-amd64/#{version}/elide.tgz"
      sha256 "26eb0e66d08d97911db9d021051f87a448015a48ddfebc36e7f76f6a02af263c"
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
