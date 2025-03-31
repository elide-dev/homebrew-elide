class Elide < Formula
  desc "Fast polyglot runtime for JavaScript, TypeScript, and Python"
  homepage "https://elide.dev"
  version "1.0.0-beta2"
  license "MIT"
  
  on_macos do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide-#{version}-darwin-aarch64.tgz"
      sha256 "a203514876b9df57cc47355ae3154b8b5becefe74d3e3fbfbc63520a2b16fece"
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
      sha256 "91233af9abf04a7a52a1ed43cfad50bcdf3464810c252d673399aeb8db8e531a"
    end
  end
  
  def install
    bin.install "bin/elide"
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