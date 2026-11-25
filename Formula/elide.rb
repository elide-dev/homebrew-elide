class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.4+20261125"
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
      sha256 "93c62d27f4fc380f74b47814e93a345d1d7a48ee52bae3530799a42cc012706e"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261125/elide.python.macos-arm64.txz"
        sha256 "f9db245e84018846eff8000a0404069b9b7242bb77e0094d09a60bdc7713ba5f"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "29e9be3da9b460657699316761bf74c2e4f2cdc00f01482dc56bb093e21e91c7"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261125/elide.python.linux-arm64.txz"
        sha256 "a43ba63b28e73ab81e9b23dde71fd6a2ef0fc248da1de98e5bf78859277a6199"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "2b547d1448c5f5765b0b41d1c20a9173e7718aa91c0fdd93b2bdb9e2aec3be3b"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261125/elide.python.linux-amd64.txz"
        sha256 "922abe75242eb07befac3d47ca1e4dac16c032674eacd6aeb6674b6c006d3f7f"
      end
    end
  end

  def install
    # A ~600MB debug build of the same binary; not needed to run Elide.
    rm "bin/elide.debug" if File.exist?("bin/elide.debug")

    resource("python").stage { cp_r Dir["*"], buildpath }
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/elide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elide --version")
  end
end
