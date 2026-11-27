class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.4+20261127"
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
      sha256 "bff512ec06744286cb43b40bf8bca1bde91a33a3475c692d7b22326c44e58d88"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261127/elide.python.macos-arm64.txz"
        sha256 "adb049910a4b8b6ac98e1419a9c7f9589710e771743118736826b7231ecdbda0"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "18a0ab9c5eaef57f221074e4f8ba3fe24c7b032c8a627a0c9d072383114a6e7b"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261127/elide.python.linux-arm64.txz"
        sha256 "69ebec8f1210a8a3e3cb99dd4d263f7a251a7e3a1009846380e6e54825da6ec8"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "2b20e063cf51ac2ba936a5a4c27659f18d6b4e10176cef32144b50357d52ac1e"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261127/elide.python.linux-amd64.txz"
        sha256 "78c125529d6fe412a29a46327b855267b62f4b52e9e007e29f1df30067772af4"
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
