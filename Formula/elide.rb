class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.4+20261123"
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
      sha256 "f6f560b3cf63e42f860501bba2623cb6d2fc34e57937e0618e6470840e111d12"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261123/elide.python.macos-arm64.txz"
        sha256 "696acfa0b82b362274c312a09ef56bed0742d53ee971701327d8540db93f5b96"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "2f5799552ddf42bb65b56b2ec483d69a08a72f51e864f5551e5fa797a8377113"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261123/elide.python.linux-arm64.txz"
        sha256 "9fa97fecf31800b176d4423ae91fead19f69c437c75b160964f191319eeacd48"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "a274ed3f233a42809f71f1f98b34e2cf93320f1f024bcbf0b8f49f9912c20cb1"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261123/elide.python.linux-amd64.txz"
        sha256 "81ad314b4400b653a5895c38813bfc167db686960c491622e17a7ad3bf222183"
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
