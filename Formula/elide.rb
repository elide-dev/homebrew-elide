class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.5.1+20260903"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_releases
    # Deliberately matches only `<semver>+<datestamp>` nightly tags. Revisit once
    # we have stable releases.
    regex(/^(\d+(?:\.\d+)+\+\d+)$/i)
  end

  on_macos do
    # Only Apple Silicon archives are published upstream.
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.macos-arm64.txz"
      sha256 "5d6cc8c502009835f39c3d3c446a26f3def266885003152d84ae445bc20810cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "d3e6692f9d69a823480c2e5e03377d905e4f202152c30910c14726f759b085c3"
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "58d96e854097cfb6ece5dcf189184f7f6c13944c80870be0cb7c08afa71c84c4"
    end
  end

  def install
    # A ~600MB debug build of the same binary; not needed to run Elide.
    rm "bin/elide.debug" if File.exist?("bin/elide.debug")

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/elide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elide --version")
  end
end
