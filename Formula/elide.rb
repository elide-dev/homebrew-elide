class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.0+20261027"
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
      sha256 "f4cce560583060d52a7507b21a0cfb411b68115b5b96b35b87de1d6e4d5dd4e2"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261027/elide.python.macos-arm64.txz"
        sha256 "fa539b15b55bfcb357380dfafe1924210b85b66b2291c72e7b6bcf0e26d5f0ba"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "f9ed396cc0f2d793dd6af5c0e66fbe9cbd4e65cda76a1d479aca0a6639a948aa"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261027/elide.python.linux-arm64.txz"
        sha256 "a597a82c56819eeec1b4eabb94b7f163955f38ef112beae55bd31f7c93f0de13"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "a85d3c12bac90581ebc7eeb9f1dd2dd8b3e57204eb16b63abc0fc0ee4b79d4e1"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261027/elide.python.linux-amd64.txz"
        sha256 "1dcdf11c5bc0cef65f01a50fa93684f7d3945350d500b4e59eb35d3cbc964db4"
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
