class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.2+20261102"
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
      sha256 "17f8c538ac404fffcf2c72496abfc290d1c284fadd70a07bb1e0a318f40e5e75"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.2+20261102/elide.python.macos-arm64.txz"
        sha256 "c935ce354dbc115e3f5d6129f7ff3a0c16a3eee27f26457bf2f24363be2d1c0f"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "9597aa8cb9ff99e270891592ee8bb801193850d59937439150d16fa3156f5746"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.2+20261102/elide.python.linux-arm64.txz"
        sha256 "96322ffcdc34a69d102f0cf08e4b5bbff1da8a07965bf608cbe131e8442e22e4"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "0f2a6b36f1321dde598ed084caa0b19808286658ec7eded253eedde8eb16b5c3"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.2+20261102/elide.python.linux-amd64.txz"
        sha256 "20088e66e0a06b11493f2153c18aef8d0de98d5f4dff4c4669ccab45f144cf88"
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
