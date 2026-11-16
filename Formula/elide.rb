class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.4+20261116"
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
      sha256 "b930f51da7cceac20d73d6d8d4bc4328785ae93f3794791879b03537a2941dfe"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261116/elide.python.macos-arm64.txz"
        sha256 "3e805802f876edd326178bc4bae575fc83e43393f36649a8647f2f4296ce755e"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "e2d6d94952af048bc74586a509998410e123303524ce1eff00bc7427e4e02d8e"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261116/elide.python.linux-arm64.txz"
        sha256 "598fdfc54d4ab0a74e009833f43b398b69f7d0dea74daf2a42a1ba57b94cca43"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "5d8a9bd11570202e29c5cd0174e41c2be015561e894ba963b26e9ed55869e5d0"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261116/elide.python.linux-amd64.txz"
        sha256 "11c88f709e5eca37f3b7a6eacc6e7110d38caa83faf92195b75a4f6b786b9483"
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
