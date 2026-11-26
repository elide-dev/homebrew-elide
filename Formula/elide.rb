class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.6.4+20261126"
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
      sha256 "a0a9f9e2b158f493fc3d09611bf97d9c6c1f66f12181759a14835613cf43361e"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261126/elide.python.macos-arm64.txz"
        sha256 "f77043b33bc6fdb914de715af285283044630c9064ad5a03653b07f6789fc41f"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "eab49b1e014430cbb2cc62f055daffb49e1e0b9bf91fbfc471a80821a8ac2a2c"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261126/elide.python.linux-arm64.txz"
        sha256 "0576d6fcf07b728bb0635ea2a40a3cbfb1419ac5fb6cb75cceb305d6759142af"
      end
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "e1ef462ccb145cf72c9250a81e9c24efe4dd227fd9a3a64e1a4b0989401797f9"
      resource "python" do
        url "https://github.com/elide-dev/elide/releases/download/1.6.4+20261126/elide.python.linux-amd64.txz"
        sha256 "58d6c498ae30ea755266433e16a88c458236c6ca3e5fbd3b2fb8421df7fcee8c"
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
