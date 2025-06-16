class Elide < Formula
  desc "Fast polyglot runtime for JavaScript, TypeScript, and Python"
  homepage "https://elide.dev"
  version "1.0.0-beta6"
  license "MIT"
  
  on_macos do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide-#{version}-darwin-aarch64.txz"
      sha256 "acad422aa98430820bc294d1782c24b098603845d903cd46c1cb03d0c827bb82"
    end
    on_intel do
      # macOS Intel not available in this version
      # Will be available in future releases
      raise "Elide #{version} does not support macOS Intel. Only ARM64 (Apple Silicon) is supported."
    end
  end
  
  on_linux do
    on_arm do
      # Linux ARM64 not available in this version
      # Will be available in future releases
      raise "Elide #{version} does not support Linux ARM64. Only AMD64 is supported."
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide-#{version}-linux-amd64.tgz"
      sha256 "69d29995a5b13387677bafd4aea22e29f0e14ed0d3de7eaa46e23983fdb90a08"
    end
  end
  
  def install
    bin.install "elide"
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