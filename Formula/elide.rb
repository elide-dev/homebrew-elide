class Elide < Formula
  desc "Fast runtime, compiler and toolchain for JVM, JavaScript and Python"
  homepage "https://elide.dev"
  version "1.4.4+20260822"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
    # Deliberately matches ONLY `<semver>+<datestamp>` nightly tags. The `url`
    # below interpolates `#{version}` straight into the download path, so the
    # only version this formula can resolve is one where the release tag and
    # the version are the same string — true for nightly, false for a stable
    # release (tag `v1.5.0`, version `1.5.0`) and for preview
    # (`preview-20260824`). A looser `^v?…(\+\d+)?$` reports `1.5.0` off the
    # first stable release, which 404s for anyone who acts on it. Nightlies
    # are published non-prerelease with `--latest` on purpose (so setup-elide's
    # `releases/latest` resolves to them), which means `:github_latest`
    # alternates between channels whose tag→version mappings differ.
    # The `i` flag is required by `brew style`
    # (FormulaAudit/LivecheckRegexCaseInsensitive) even though the pattern has
    # no letters to fold.
    regex(/^(\d+(?:\.\d+)+\+\d+)$/i)
  end

  on_macos do
    # Only Apple Silicon archives are published upstream.
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.macos-arm64.txz"
      sha256 "b328fc12985a43a90b059ff5de3f060f23d1caf6e5fa7e7f9d73b1291d2effe4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-arm64.txz"
      sha256 "c59cb55e5143fa4837eb1bfc2494961263bb2577a66457ab7cacb886ec2f8f89"
    end
    on_intel do
      url "https://github.com/elide-dev/elide/releases/download/#{version}/elide.linux-amd64.txz"
      sha256 "5c2f9eb5ad7dad91c65313f529dda8d8bf60d969914d1523577abebb31ea2824"
    end
  end

  def install
    # A ~600MB debug build of the same binary; not needed to run Elide.
    rm "bin/elide.debug" if File.exist?("bin/elide.debug")

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/elide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elide --version")
  end
end
