class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.4+20261128"
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
      sha256 "6b47599adfccdab479fc08f327dd7aaf67ca2de79bce46e31786a12b80b39f1c"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261128/elide.python.macos-arm64.txz"
        sha256 "5b4d57c1d307597ed1c11c5b1b60f8268bb4d30803389d5dedad408983fcd2e6"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "15572c23f044449e1649b045998ba7cd72eb468b3fcd87cd27aa62d8a363fb53"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261128/elide.python.linux-arm64.txz"
        sha256 "4e8e1327f1df6b3d1d698ec4a664f18f46445bb891052e4d738267efee430b92"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "b23c8fceedd1bbc0888428e0b40db24649632c6936f357cfc929e30268b28641"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261128/elide.python.linux-amd64.txz"
        sha256 "e58f46ca920cf0edff67aab3a5866e6be3b2fb148529b0182f6227f224bf3ca8"
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
