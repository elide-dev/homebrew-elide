class Elide < Formula
  desc "Fast polyglot runtime for JavaScript, TypeScript, and Python"
  homepage "https://elide.dev"
  version "1.0.0-beta7"
  license "MIT"
  
  on_macos do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/darwin-aarch64/#{version}/elide.txz"
      sha256 "130e0efcb6f253eac9527dac150d47b34b9c0be7c4f43660fe79f33d007cbc85"
    end
    on_intel do
      # macOS Intel not available in this version
      # Will be available in future releases
      raise "Elide #{version} does not support macOS Intel. Only ARM64 (Apple Silicon) is supported."
    end
  end
  
  on_linux do
    on_arm do
      url "https://elide.zip/cli/v1/snapshot/linux-aarch64/#{version}/elide.tgz"
      sha256 "e43beb097b06ffbcada13f595cda532c2e81ae5b8001785253d9926729392b50"
    end
    on_intel do
      url "https://elide.zip/cli/v1/snapshot/linux-amd64/#{version}/elide.tgz"
      sha256 "2cbd9d45f5904390b303a1963379cc3e68591cf09aa875bff260cf1fb45bfe38"
    end
  end
  
  def install
    bin.install "elide"
    bin.install Dir["resources"]
    # Install docs if they exist
    doc.install Dir["docs/*"] if Dir.exist?("docs")
    # Install man pages if they exist
    man1.install Dir["man/*.1"] if Dir.exist?("man")
  end
  
  test do
    # Add a test to verify installation
    assert_match version.to_s, shell_output("#{bin}/elide --version")
  end
end
