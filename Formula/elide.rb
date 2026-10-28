class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.0+20261028"
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
      sha256 "8bba18bc51aa550b3fb11222d521e7eaaf3490a828315ac0e4708157e17fca08"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261028/elide.python.macos-arm64.txz"
        sha256 "04dc65acefb41170d8193538fc742ab4c99f20d6496c84a8e379436c450747dc"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "d5b766291bf4d92da8d8cdd2ec53e131a5f15d542410fa0162f8b27a8ae38a8e"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261028/elide.python.linux-arm64.txz"
        sha256 "9f51c00aa47e74848ada6ab6ac62394976d3f66cf7194c246ff3ec7f0966ed7c"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "2e2098f761024f4d63a018e6d7a643f6824f3797b21988e181e3ba264b616060"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.0+20261028/elide.python.linux-amd64.txz"
        sha256 "87616abb689e05c8d9d0f0b2b9a022cbeba79caf204e1f9bab06f7dd4c22df36"
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
