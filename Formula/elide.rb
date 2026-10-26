class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.0+20261026"
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
      sha256 "9bbddc23d1ad79a53f549741663decde6dbc7b34b3b9eecd2db885ede92f5d0f"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261026/elide.python.macos-arm64.txz"
        sha256 "ae71f370f3bc905b3dedbf3d794f4fc94aec6f5e81760be09c4c0617c380d4cd"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "36e2c77b9fe46cf06a42a74de3a7f852966d30a4d67c434ab9ff401ca8eb7ffa"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261026/elide.python.linux-arm64.txz"
        sha256 "b45b4be9ef1ff2c7bb163c771021e2a822d08ab1edfd0309ccd5814ab8454c59"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "3ea247c6e2fd86aeb18ec1fc973af40f16fe3feda8c0dbcec17e07d53ada84b7"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261026/elide.python.linux-amd64.txz"
        sha256 "a06c5ae01e914fcffbae8a6652a5a61b9def0133d4e6923738789519a52f5610"
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
