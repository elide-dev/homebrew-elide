class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.4+20261121"
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
      sha256 "d7c9605d4233c48ff3b305fa95203f089ee3f65e5e09b1525326aba142e8de21"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261121/elide.python.macos-arm64.txz"
        sha256 "0795c9f5b10a7cd3db9c7723631a4073d1b3c1aaf10ea5fadcb4022ed8903d5a"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "26bca5360b53a5812a02d7eef9152897ba85265aff16d7869b9a34a7c66e0135"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261121/elide.python.linux-arm64.txz"
        sha256 "6b201c35964e07895958822ac97babab00d9df66d65fd78927ab030b161d9bed"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "eed659ac47c8bfb92ff0b5288af065409aae3a0330b346da91d1634f56152520"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261121/elide.python.linux-amd64.txz"
        sha256 "29108d66ac5cf81ef926daccb31747de9b2d4dd1609f4fa0e94350d540af671a"
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
