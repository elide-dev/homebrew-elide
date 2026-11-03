class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.2+20261103"
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
      sha256 "fc84e7651640660d4ad710b55bb119bdd2db9091296050d3fd381dd593a9b204"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.2+20261103/elide.python.macos-arm64.txz"
        sha256 "4bd8b809c06b511e956848e4b68731430135c5fd73c7faecb2bc816fdb2baa9b"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "003d6256ad1a7bdcf26ef7d87ae2cdd74d913c0212d3f8c16ee0b58278ebf606"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.2+20261103/elide.python.linux-arm64.txz"
        sha256 "f742fba1ac9efc2c748db071be0eea296ef4574fed9ee286a8d2ee7da55e9b91"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "b277a4325c66ad7aaff3df116de34ef62ea84d710549e516317fdc6c723d5392"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.2+20261103/elide.python.linux-amd64.txz"
        sha256 "aab61633cd0358d0584c2d9c7ab0fc6af77d90cbc761b23be75913d0a6b01759"
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
