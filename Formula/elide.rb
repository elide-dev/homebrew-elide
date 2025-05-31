class Elide < Formula
  desc "Fast polyglot runtime for JavaScript, TypeScript, and Python"
  homepage "https://elide.dev"
  version "1.0.0-beta5"
  license "MIT"
  
  on_macos do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide-#{version}-darwin-aarch64.txz"
      sha256 "14c1352935633b77b386f7309341e200e950477b70456c629ee833fa01c487e9"
    end
    on_intel do
      # macOS Intel not available in beta2
      # Will be available in future releases
      raise "Elide #{version} does not support macOS Intel. Only ARM64 (Apple Silicon) is supported."
    end
  end
  
  on_linux do
    on_arm do
      # Linux ARM64 not available in beta2
      # Will be available in future releases
      raise "Elide #{version} does not support Linux ARM64. Only AMD64 is supported."
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide-#{version}-linux-amd64.tgz"
      sha256 "506c6a7aec98c7ac8aea10e365ac0706d0eedb70e45158d009695348afe28dca"
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