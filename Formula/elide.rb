class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.3+20261111"
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
      sha256 "d1aec6c2c813e34529cecaea716f7be3ba6bbf9fc1d1950579c5a1b03349b255"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.3+20261111/elide.python.macos-arm64.txz"
        sha256 "be733d977eeadb5780608a5a816cc39330891dd91989c795dc42590d2a2723a8"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "43e53caa91a942afc1cc269a4aae6c0e9db27bd3e3ac0cb0e5a8adfdd0a7f301"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.3+20261111/elide.python.linux-arm64.txz"
        sha256 "b2138ed64d9ce63de4683e808f58ee59c91ac44525dea37bb9696be64b5195b0"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "f5d82293b74025bda2782aef224e1bb726baaab7db066fe47bfc85421556c04a"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.3+20261111/elide.python.linux-amd64.txz"
        sha256 "c8daee3c88b14aa2c3b0528bec1a16fc5854bd825e42badc9275fa9fe5ffc8a1"
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
